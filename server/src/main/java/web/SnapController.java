package web;

import domain.Snap;
import domain.SnapPublishedEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import service.SnapService;

import java.util.List;

@Controller
@MessageMapping("/snap")
public class SnapController {

    @Autowired
    private SnapService snapService;


	@MessageMapping("/create")
    Snap create(Snap snap) {
        return snapService.create(snap);
    }

	@MessageMapping("/{id}")
	Snap getSnapById(@DestinationVariable int id) {
		return snapService.getSnapById(id);
	}

	@MessageMapping
    List<Snap> getSnapsFromRecipient(String username) {
        return snapService.getSnapsFromRecipient(username);
    }

	@MessageMapping("/delete/{id}")
    void delete(@DestinationVariable int id) {
        snapService.delete(id);
    }

}
