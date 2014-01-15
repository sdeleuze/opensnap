package web;

import domain.Snap;
import domain.SnapPublishedEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;
import service.SnapService;

import java.util.List;

@RestController
@RequestMapping("/api/snap")
public class SnapController implements ApplicationListener<SnapPublishedEvent> {

    @Autowired
    private SnapService snapService;


    @RequestMapping(method = RequestMethod.POST)
    Snap create(@RequestBody Snap snap) {
        return snapService.create(snap);
    }

    @RequestMapping("{username}")
    List<Snap> getSnapsFromRecipient(@PathVariable String username) {
        return snapService.getSnapsFromRecipient(username);
    }

    @RequestMapping(value = "{id}", method = RequestMethod.DELETE)
    void delete(@PathVariable int id) {
        snapService.delete(id);
    }

    @Override
    public void onApplicationEvent(SnapPublishedEvent event) {
        // Will be used to send update notification when using STOMP over Websocket
    }


}
