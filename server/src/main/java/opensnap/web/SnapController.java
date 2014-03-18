package opensnap.web;

import opensnap.domain.Snap;
import opensnap.domain.SnapPublishedEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import opensnap.service.SnapService;

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

	@MessageMapping("/delete/{id}/{username}")
	void delete(@DestinationVariable int id, @DestinationVariable String username) {
		snapService.delete(id, username);
	}


}
