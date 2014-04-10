package opensnap.service;

import opensnap.Queue;
import opensnap.Topic;
import opensnap.domain.Snap;

import opensnap.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
public class DefaultSnapService implements SnapService {

	private Set<Snap> snaps;
	AtomicInteger snapCounter = new AtomicInteger(1);
	private final SimpMessagingTemplate template;

	@Autowired
	public DefaultSnapService(SimpMessagingTemplate template) {
		this.snaps = Collections.synchronizedSet(new LinkedHashSet<Snap>());
		this.template = template;
	}

	@Override
	public Snap create(Snap snap) {
		snap.setId(snapCounter.getAndIncrement());
		snaps.add(snap);
		template.convertAndSend(Topic.SNAP_CREATED, snap.withoutPhoto());
		for(User user : snap.getRecipients()) {
			template.convertAndSendToUser(user.getUsername(), Queue.SNAP_RECEIVED, snap.withoutPhotoAndRecipients());
		}
		return snap;
	}

	@Override
	public Snap getById(int id) {
		synchronized (snaps) {
			return snaps.stream().filter((s) -> s.getId() == id).findFirst()
					.orElseThrow(() -> new IllegalArgumentException("No snap with id " + id + " found!"));
		}
	}

	@Override
	public Set<Snap> getSnapsFromRecipient(String username) {
		synchronized (snaps) {
			return snaps.stream().filter(s -> s.getRecipients().stream().anyMatch(u -> u.getUsername().equals(username)))
					.map((s -> s.withoutPhoto())).collect(Collectors.toSet());
		}
	}

	@Override
	public void delete(int id) {
		if(!snaps.removeIf((s) -> s.getId() == id)) throw new IllegalArgumentException(id + " does not exists");
	}

	@Override
	public void delete(int id, String username) {
		Snap snap;
		synchronized (snaps) {
			snap = snaps.stream().filter(s -> s.getId() == id).findFirst().orElseThrow(() -> new IllegalArgumentException(id + " does not exists"));
		}
		snap.getRecipients().removeIf(u -> u.getUsername().equals(username));
		if(snap.getRecipients().isEmpty()) snaps.remove(snap);
	}

}
