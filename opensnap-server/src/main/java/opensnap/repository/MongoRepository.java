/*
 * Copyright 2002-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package opensnap.repository;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import opensnap.domain.Identifiable;
import org.bson.types.ObjectId;
import org.mongodb.Document;
import org.mongodb.async.MongoCollection;
import org.mongodb.async.MongoDatabase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public abstract class MongoRepository<T extends Identifiable> {

	private final MongoCollection<Document> collection;
	private static final Logger logger = LoggerFactory.getLogger(MongoRepository.class);
	private final ObjectMapper  mapper;
	private final Class<T> clazz;

	public MongoRepository(MongoDatabase db, ObjectMapper mapper, String collectionName, Class<T> clazz) {
		this.mapper = mapper;
		this.clazz = clazz;
		collection = db.getCollection(collectionName);
	}

	public CompletableFuture<T> insert(T elem) {
		CompletableFuture<T> future = new CompletableFuture<>();
		try {
			Document doc = Document.valueOf(mapper.writeValueAsString(elem));
			collection.insert(doc).register((result, e) -> {
				if (result != null && result.wasAcknowledged()) {
					elem.setId(doc.getObjectId("_id"));
					future.complete(elem);
				} else {
					logger.error("Error while creating a new document in insert() : " + doc.toString(), e);
					future.cancel(true);
				}
			});
		} catch (JsonProcessingException e) {
			logger.error("Error while creating element " + elem.toString() + " in insert()", e);
			future.cancel(true);
		}
		return future;
	}

	public CompletableFuture<T> getOne(String key, Object value) {
		CompletableFuture<T> future = new CompletableFuture<>();

		collection.find(new Document(key, value)).one().register((document, e) -> {
				try {
					if (document != null) {
						future.complete(mapper.readValue(document.toString(), clazz));
					} else {
						logger.error("No document with attribute " + key + "=" + value + " found",  e);
						future.cancel(true);
					}
				} catch (IOException ex) {
					logger.error("Error while parsing document in getOne() : "  + document.toString(), ex);
					future.cancel(true);
				}
			});
		return future;
	}

	public CompletableFuture<T> getById(String id) {
		return this.getOne("_id", new ObjectId(id));
	}

	public CompletableFuture<List<T>> getSome(String key, Object value) {
		CompletableFuture<List<T>> future = new CompletableFuture<>();
		List<T> list = new ArrayList<>();

		collection.find(new Document(key, value)).forEach((document) -> {
			try {
				list.add(mapper.readValue(document.toString(), clazz));
			} catch (IOException e) {
				logger.error("Error while parsing document in getSome() : " + document.toString(), e);
			}
		}).register((result, e) -> future.complete(list));;
		return future;
	}

	public CompletableFuture<List<T>> getAll() {
		CompletableFuture<List<T>> future = new CompletableFuture<>();
		List<T> list = new ArrayList<>();

		collection.find(Document.valueOf("{_id:{ $exists: true }}")).forEach((document) -> {
			try {
				list.add(mapper.readValue(document.toString(), clazz));
			} catch (IOException e) {
				logger.error("Error while parsing document in getAll() : " + document.toString(), e);
			}

		}).register((result, e) -> future.complete(list));
		return future;
	}

	public void remove(String id) {
		throw new UnsupportedOperationException("Remove operation not yet implemented in MongoDB async driver");
	}

	public CompletableFuture<Long> count(String key, Object value) {
		CompletableFuture<Long> future = new CompletableFuture<>();
		collection.find(new Document(key, value)).count().register((count, e) -> future.complete(count));
		return future;
	}
}
