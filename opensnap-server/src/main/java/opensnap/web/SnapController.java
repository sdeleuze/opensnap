package opensnap.web;

import opensnap.Queue;
import opensnap.domain.Snap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
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

	@Autowired
	public SnapController(SnapService snapService) {
		this.snapService = snapService;
	}

	@MessageMapping("/create")
	@SendToUser(Queue.SNAP_CREATED)
	Snap create(Snap snap) {
		return snapService.create(snap);
	}

	@SubscribeMapping("/id/{id}")
	Snap getById(@DestinationVariable int id) {
		return snapService.getById(id);
	}

	@SubscribeMapping("/received")
	List<Snap> getReceivedSnaps(Principal principal) {
		return snapService.getSnapsFromRecipient(principal.getName())
				.stream().map((s -> s.withoutPhotoAndRecipients())).collect(Collectors.toList());
	}

	@SubscribeMapping("/sent")
	List<Snap> getSentSnaps(Principal principal) {
		return snapService.getSnapsFromAuthor(principal.getName())
			.stream().map((s -> s.withoutPhoto())).collect(Collectors.toList());
	}

	@SubscribeMapping("/delete/{id}")
	void delete(@DestinationVariable int id) {
		snapService.delete(id);
	}

	@SubscribeMapping("/delete-for-authenticated-user/{id}")
	void deleteForUser(@DestinationVariable int id, Principal principal) {
		snapService.delete(id, principal.getName());
	}

}
