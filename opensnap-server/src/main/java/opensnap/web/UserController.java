package opensnap.web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import opensnap.domain.User;
import opensnap.service.UserService;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@MessageMapping("/usr")
public class UserController {

	private final UserService userService;

	@Autowired
	public UserController(UserService userService) {
		this.userService = userService;
	}

	@MessageMapping("/auth")
	Boolean authenticate(User user) {
		return userService.authenticate(user);
	}

	@MessageMapping
	List<User> getUsers() {
		return userService.getAllUsers().stream().map((u -> u.withoutPassword())).collect(Collectors.toList());
	}

}