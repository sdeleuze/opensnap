package opensnap.web;

import opensnap.domain.Snap;
import opensnap.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import opensnap.service.SnapService;

import java.util.List;

@Controller
@MessageMapping("/snap")
public class SnapController {

    private final SnapService snapService;
	private final SimpMessagingTemplate template;

	@Autowired
	public SnapController(SnapService snapService, SimpMessagingTemplate template) {
		this.snapService = snapService;
		this.template = template;
	}

	@MessageMapping("/create")
    Snap create(Snap snap) {
		Snap newSnap = snapService.create(snap);
		Runnable notifyClients = () -> {
			for(User user : snap.getRecipients()) {
				template.convertAndSendToUser(user.getUsername(), "/queue/snap/published", new Integer(snap.getId()));
			}
		};
		notifyClients.run();
        return newSnap;
    }

	@MessageMapping("/{id}")
	Snap getSnapById(@DestinationVariable int id) {
		return snapService.getById(id);
	}

	@MessageMapping
    List<Snap> getSnapsFromRecipient(String username) {
        return snapService.getSnapsFromRecipient(username);
    }

	@MessageMapping("/delete/{id}")
    void delete(@DestinationVariable int id) {
        snapService.delete(id);
    }

	@MessageMapping("/delete/{id}/{username}")
	void delete(@DestinationVariable int id, @DestinationVariable String username) {
		snapService.delete(id, username);
	}

}
