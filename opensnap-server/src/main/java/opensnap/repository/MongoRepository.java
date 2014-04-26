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
import opensnap.domain.Snap;
import org.mongodb.AsyncBlock;
import org.mongodb.Document;
import org.mongodb.MongoCollection;
import org.mongodb.MongoDatabase;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CompletableFuture;

public abstract class MongoRepository<T> {

	private final MongoDatabase db;
	private final MongoCollection<Document> collection;
	private static final Logger logger = LoggerFactory.getLogger(MongoRepository.class);
	private final ObjectMapper  mapper;
	private final Class<T> clazz;

	public MongoRepository(MongoDatabase db, ObjectMapper mapper, String collectionName, Class<T> clazz) {
		this.db = db;
		this.mapper = mapper;
		this.clazz = clazz;
		collection = db.getCollection(collectionName);
	}

	public CompletableFuture<T> insert(T elem) {
		CompletableFuture<T> future = new CompletableFuture<>();
		try {
			Document doc = Document.valueOf(mapper.writeValueAsString(elem));
			collection.asyncInsert(doc).register((result, e) -> {
				if (result != null && result.wasAcknowledged()) {
					future.complete(elem);
				} else {
					logger.error("Error while creating a new Snap: " + e);
					future.cancel(true);
				}
			});
		} catch (JsonProcessingException e) {
			logger.error("Error while creating a new Snap: " + e);
			future.cancel(true);
		}
		return future;
	}

	public CompletableFuture<T> getOne(String key, Object value) {
		CompletableFuture<T> future = new CompletableFuture<>();

		collection.find(new Document(key, value)).asyncOne().register((document, e) -> {
				try {
					if (document != null) {
						future.complete(mapper.readValue(document.toString(), clazz));
					} else {
						logger.error("Error while parsing Snap: " + e);
						future.cancel(true);
					}
				} catch (IOException ex) {
					logger.error("Error while parsing Snap: " + ex);
					future.cancel(true);
				}
			});
		return future;
	}

	public CompletableFuture<List<T>> getSome(String key, Object value) {
		CompletableFuture<List<T>> future = new CompletableFuture<>();

		collection.find(new Document(key, value)).asyncForEach(new AsyncBlock<Document>() {
			List<T> list = new ArrayList<>();
			@Override
			public void done() {
				future.complete(list);
			}
			@Override
			public void apply(Document document) {
				try {
					list.add(mapper.readValue(document.toString(), clazz));
				} catch (IOException e) {
					logger.error("Error while parsing Snap: " + e.getMessage());
				}

			}
		});
		return future;
	}

	public CompletableFuture<List<T>> getAll() {
		CompletableFuture<List<T>> future = new CompletableFuture<>();

		collection.find().asyncForEach(new AsyncBlock<Document>() {
			List<T> list = new ArrayList<>();
			@Override
			public void done() {
				future.complete(list);
			}
			@Override
			public void apply(Document document) {
				try {
					list.add(mapper.readValue(document.toString(), clazz));
				} catch (IOException e) {
					logger.error("Error while parsing Snap: " + e.getMessage());
				}

			}
		});
		return future;
	}

	public void remove(String key, Object value) {
		collection.find(new Document(key, value)).removeOne();
	}

	public long count(String key, Object value) {
		return collection.find(new Document(key, value)).count();
	}
}
