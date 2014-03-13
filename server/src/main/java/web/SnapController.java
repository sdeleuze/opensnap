package web;

import domain.Snap;
import domain.SnapPublishedEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import service.SnapService;

import java.util.List;

@Controller
@MessageMapping("/snap")
public class SnapController implements ApplicationListener<SnapPublishedEvent> {

    @Autowired
    private SnapService snapService;


	@MessageMapping("/create")
    Snap create(Snap snap) {
        return snapService.create(snap);
    }

	@MessageMapping
    List<Snap> getSnapsFromRecipient(String username) {
        return snapService.getSnapsFromRecipient(username);
    }

	@MessageMapping("/delete")
    void delete(int id) {
        snapService.delete(id);
    }

    @Override
    public void onApplicationEvent(SnapPublishedEvent event) {
        // Will be used to send update notification when using STOMP over Websocket
    }


}
