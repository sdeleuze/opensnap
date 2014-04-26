package opensnap.web;

import opensnap.Queue;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;
import opensnap.domain.User;
import opensnap.service.UserService;

import java.security.Principal;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
@MessageMapping("/usr")
public class UserController  extends AbstractStompController {

	private final UserService userService;
	private final SimpMessagingTemplate template;

	@Autowired
	public UserController(UserService userService, SimpMessagingTemplate template) {
		this.userService = userService;
		this.template = template;
	}

	@MessageMapping("/signup")
	public void signup(User user, Principal principal) {
		userService.signup(user).thenAccept(createdUser ->
			template.convertAndSendToUser(principal.getName(), Queue.USER_CREATED, createdUser)
		);
	}

	@MessageMapping("/authenticated")
	public void getAuthenticatedUser(Principal principal) {
		userService.getByUsername(principal.getName()).thenAccept(user ->
			template.convertAndSendToUser(principal.getName(), Queue.USER_AUTHENTICATED, user.withoutPassword())
		);
	}

	@SubscribeMapping("/all")
	public void getAllUsers(Principal principal) {
		userService.getAllUsers().thenAccept(users ->
			template.convertAndSendToUser(principal.getName(), Queue.USER_ALL, users.stream().map((u -> u.withoutPasswordAndRoles())).collect(Collectors.toSet()))
		);
	}

}