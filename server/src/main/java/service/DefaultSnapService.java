package service;

import domain.Snap;
import domain.SnapPublishedEvent;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ApplicationEventPublisherAware;

import java.util.*;

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

    public List<Snap> getSnapsFromRecipient(String username) {
        List<Snap> recipientSnaps = new ArrayList<Snap>();
        for(Snap snap : snaps) {
            if(snap.getRecipient().getUsername().equals(username))
                recipientSnaps.add(snap);
        }
        return recipientSnaps;

    }

    public void delete(int id) {
        for(Snap snap : snaps) {
            if(snap.getId() == id) {
                snaps.remove(snap);
                return;
            }
        }
        throw new IllegalArgumentException(id + " does not exists");
    }

    @Override
    public void setApplicationEventPublisher(ApplicationEventPublisher applicationEventPublisher) {
        this.publisher = applicationEventPublisher;
    }
}
