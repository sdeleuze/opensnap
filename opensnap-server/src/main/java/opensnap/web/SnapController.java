package opensnap.web;

import opensnap.Queue;
import opensnap.domain.Snap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;
import opensnap.service.SnapService;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@MessageMapping("/snap")
public class SnapController extends AbstractStompController {

	private final SnapService snapService;
	private final SimpMessagingTemplate template;

	@Autowired
	public SnapController(SnapService snapService, SimpMessagingTemplate template) {
		this.snapService = snapService;
		this.template = template;
	}

	@MessageMapping("/create")
	void create(Snap snap, Principal principal) {
		snapService.create(snap).thenAccept(createdSnap ->
			template.convertAndSendToUser(principal.getName(), Queue.SNAP_CREATED, createdSnap)
		);
	}

	@MessageMapping("/id/{id}")
	void getById(@DestinationVariable Long id, Principal principal) {
		snapService.getById(id).thenAccept(snap ->
			template.convertAndSendToUser(principal.getName(), Queue.SNAP_BY_ID, snap)
		);
	}

	@MessageMapping("/received")
	void getReceivedSnaps(Principal principal) {
		snapService.getSnapsFromRecipient(principal.getName()).thenAccept(snaps -> {
			List<Snap> filteredSnaps = snaps.stream().map((s -> s.withoutPhotoAndRecipients())).collect(Collectors.toList());
			template.convertAndSendToUser(principal.getName(), Queue.SNAPS_RECEIVED, filteredSnaps);
		});
	}

	@MessageMapping("/sent")
	void getSentSnaps(Principal principal) {
		snapService.getSnapsFromAuthor(principal.getName()).thenAccept(snaps -> {
			List<Snap> filteredSnaps = snaps.stream().map((s -> s.withoutPhoto())).collect(Collectors.toList());
			template.convertAndSendToUser(principal.getName(), Queue.SNAPS_SENT, filteredSnaps);
		});
	}

	@SubscribeMapping("/delete/{id}")
	void delete(@DestinationVariable Long id) {
		snapService.delete(id);
	}

	@SubscribeMapping("/delete-for-authenticated-user/{id}")
	void deleteForUser(@DestinationVariable Long id, Principal principal) {
		snapService.delete(id, principal.getName());
	}

}
