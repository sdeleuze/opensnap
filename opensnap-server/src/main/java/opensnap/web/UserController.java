package opensnap.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;
import opensnap.domain.User;
import opensnap.service.UserService;

import java.security.Principal;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class UserController  extends AbstractStompController {

	private final UserService userService;

	@Autowired
	public UserController(UserService userService) {
		this.userService = userService;
	}

	@SubscribeMapping("/usr/authenticated")
	User getAuthenticatedUser(Principal principal) {
		return userService.getByUsername(principal.getName()).withoutPassword();
	}

	@SubscribeMapping("/usr/all")
	List<User> getAllUsers() {
		return userService.getAllUsers().stream().map((u -> u.withoutPassword())).collect(Collectors.toList());
	}

}