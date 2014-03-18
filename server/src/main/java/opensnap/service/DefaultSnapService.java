package opensnap.service;

import opensnap.domain.Snap;
import opensnap.domain.SnapPublishedEvent;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service
public class DefaultSnapService implements SnapService, ApplicationEventPublisherAware {

    private List<Snap> snaps;
    AtomicInteger snapCounter = new AtomicInteger(1);

    private ApplicationEventPublisher publisher;

    public DefaultSnapService() {
        snaps = new ArrayList<Snap>();
    }

	@Override
    public Snap create(Snap snap) {
        snap.setId(snapCounter.getAndIncrement());
        snaps.add(snap);
        publisher.publishEvent(new SnapPublishedEvent(snap));
        return snap;
    }

	@Override
	public Snap getSnapById(int id) {
		return snaps.stream().filter((s) -> s.getId() == id).findFirst()
				.orElseThrow(() -> new IllegalArgumentException("No snap with id " + id + " found!"));
	}

	@Override
	public List<Snap> getSnapsFromRecipient(String username) {
		return snaps.stream().filter(s -> s.getRecipients().stream().anyMatch(u -> u.getUsername().equals(username)))
				.map((s -> s.withoutPhoto())).collect(Collectors.toList());
    }

	@Override
    public void delete(int id) {
		if(!snaps.removeIf((s) -> s.getId() == id)) throw new IllegalArgumentException(id + " does not exists");
    }

	@Override
	public void delete(int id, String username) {
		Snap snap = snaps.stream().filter(s -> s.getId() == id).findFirst().orElseThrow(() -> new IllegalArgumentException(id + " does not exists"));
		snap.getRecipients().removeIf(u -> u.getUsername().equals(username));
		if(snap.getRecipients().isEmpty()) snaps.remove(snap);
	}

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.publisher = applicationEventPublisher;
    }
}
