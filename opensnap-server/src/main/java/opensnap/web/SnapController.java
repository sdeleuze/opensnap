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
import org.springframework.util.Assert;

import java.security.Principal;
import java.util.List;

@Controller
public class SnapController extends AbstractStompController {

	private final SnapService snapService;

	@Autowired
	public SnapController(SnapService snapService) {
		this.snapService = snapService;
	}

	@MessageMapping("/snap/create")
	@SendToUser(Queue.SNAP_CREATED)
	Snap create(Snap snap) {
		Snap newSnap = snapService.create(snap);
		return newSnap;
	}

	@SubscribeMapping("/snap/id/{id}")
	Snap getById(@DestinationVariable int id) {
		return snapService.getById(id);
	}

	@SubscribeMapping("/snap/user")
	List<Snap> getSnapsFromAuthenticatedUser(Principal principal) {
		return snapService.getSnapsFromRecipient(principal.getName());
	}

	@SubscribeMapping("/snap/delete/{id}")
	void delete(@DestinationVariable int id) {
		snapService.delete(id);
	}

	@SubscribeMapping("/snap/delete-for-authenticated-user/{id}")
	void deleteForUser(@DestinationVariable int id, Principal principal) {
		snapService.delete(id, principal.getName());
	}

}
