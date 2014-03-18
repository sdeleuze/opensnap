package opensnap.domain;

import org.springframework.context.ApplicationEvent;

public class SnapPublishedEvent extends ApplicationEvent {

    public SnapPublishedEvent(Snap snap) {
        super(snap);
    }

    public Snap getSnap() {
        return (Snap)source;
    }
}
