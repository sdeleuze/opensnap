package opensnap.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
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

	@Autowired
	public UserController(UserService userService) {
		this.userService = userService;
	}

	@SubscribeMapping("/authenticated")
	User getAuthenticatedUser(Principal principal) {
		return userService.getByUsername(principal.getName()).withoutPassword();
	}

	@SubscribeMapping("/all")
	Set<User> getAllUsers() {
		return userService.getAllUsers().stream().map((u -> u.withoutPassword())).collect(Collectors.toSet());
	}

}