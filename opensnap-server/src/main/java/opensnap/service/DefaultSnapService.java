package opensnap.service;

import com.mongodb.DBObject;

import opensnap.Queue;
import opensnap.Topic;
import opensnap.domain.Snap;

import opensnap.domain.User;
import opensnap.repository.SnapRepository;
import org.mongodb.Document;
import org.mongodb.QueryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
public class DefaultSnapService implements SnapService {

	private SnapRepository snapRepository;
	AtomicInteger snapCounter = new AtomicInteger(1);
	private final SimpMessagingTemplate template;

	@Autowired
	public DefaultSnapService(SimpMessagingTemplate template, SnapRepository snapRepository) {
		this.template = template;
		this.snapRepository = snapRepository;
	}

	@Override
	public CompletableFuture<Snap> create(Snap snap) {
		snap.setId(snapCounter.getAndIncrement());
		CompletableFuture<Snap> futureSnap = snapRepository.insert(snap);
		futureSnap.thenAccept(createdSnap -> {
			template.convertAndSend(Topic.SNAP_CREATED, snap.withoutPhoto());
			for(User user : snap.getRecipients()) {
				template.convertAndSendToUser(user.getUsername(), Queue.SNAP_RECEIVED, snap.withoutPhotoAndRecipients());
			}
		});
		return futureSnap;
	}

	@Override
	public CompletableFuture<Snap> getById(Long id) {
		return snapRepository.getOne("id", id);
	}

	@Override
	public CompletableFuture<List<Snap>> getSnapsFromRecipient(String username) {
		return snapRepository.getSome("recipient", new Document("$elemMatch" , new Document("username", username)));
	}

	@Override
	public CompletableFuture<List<Snap>> getSnapsFromAuthor(String username) {
		return snapRepository.getSome("author", username);
	}

	@Override
	public void delete(Long id) {
		snapRepository.remove("id", id);
	}

	@Override
	public void delete(Long id, String username) {
		snapRepository.getOne("id", id).thenAccept(snap -> {
			snap.getRecipients().removeIf(u -> u.getUsername().equals(username));

			if(snap.getRecipients().isEmpty()) {
				delete(id);
				this.template.convertAndSendToUser(snap.getAuthor().getUsername(), Queue.SNAP_DELETED, snap);
			} else {
				snapRepository.insert(snap);
			}
		});
	}

}
