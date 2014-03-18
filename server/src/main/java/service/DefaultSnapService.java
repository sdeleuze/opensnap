package service;

import domain.Snap;
import domain.SnapPublishedEvent;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;

import java.util.*;
import java.util.stream.Collectors;

public class DefaultSnapService implements SnapService, ApplicationEventPublisherAware {

    private List<Snap> snaps;
    int snapCounter = 1;

    private ApplicationEventPublisher publisher;

    public DefaultSnapService() {
        snaps = new ArrayList<Snap>();
    }

    public Snap create(Snap snap) {
        snap.setId(snapCounter++);
        snaps.add(snap);
        publisher.publishEvent(new SnapPublishedEvent(snap));
        return snap;
    }

	@Override
	public Snap getSnapById(int id) {
		return snaps.stream().filter((s) -> s.getId() == id).findFirst()
				.orElseThrow(() -> new IllegalArgumentException("No snap with id " + id + " found!"));
	}

	public List<Snap> getSnapsFromRecipient(String username) {
		return snaps.stream().filter(s -> s.getRecipient().getUsername().equals(username))
				.map((s -> s.withoutPhoto())).collect(Collectors.toList());
    }

    public void delete(int id) {
		if(!snaps.removeIf((s) -> s.getId() == id))
			throw new IllegalArgumentException(id + " does not exists");
    }

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.publisher = applicationEventPublisher;
    }
}
