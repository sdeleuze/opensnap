package opensnap.web;

import opensnap.domain.Snap;
import opensnap.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;
import opensnap.service.SnapService;

import java.util.List;

@Controller
public class SnapController extends AbstractStompController {

	private final SnapService snapService;

	@Autowired
	public SnapController(SnapService snapService) {
		this.snapService = snapService;
	}

	@MessageMapping("/snap/create")
	@SendToUser("/queue/snap-created")
	Snap create(Snap snap) {
		Snap newSnap = snapService.create(snap);
		return newSnap;
	}

	@SubscribeMapping("/snap/id/{id}")
	Snap getSnapById(@DestinationVariable int id) {
		return snapService.getById(id);
	}

	@SubscribeMapping("/snap/username/{username}")
	List<Snap> getSnapsFromRecipient(@DestinationVariable String username) {
		return snapService.getSnapsFromRecipient(username);
	}

	@SubscribeMapping("/snap/delete/{id}")
	void delete(@DestinationVariable int id) {
		snapService.delete(id);
	}

	@SubscribeMapping("/snap/delete/{id}/{username}")
	void delete(@DestinationVariable int id, @DestinationVariable String username) {
		snapService.delete(id, username);
	}

}
