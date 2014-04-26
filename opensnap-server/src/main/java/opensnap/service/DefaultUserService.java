package opensnap.service;

import opensnap.*;
import opensnap.domain.Snap;
import opensnap.domain.User;
import opensnap.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class DefaultUserService implements UserService {

	private UserRepository userRepository;
	private SimpMessagingTemplate template;
	private PasswordEncoder passwordEncoder;

	@Autowired
	public DefaultUserService(PasswordEncoder passwordEncoder, UserRepository userRepository) {
		this.userRepository = userRepository;
		this.passwordEncoder = passwordEncoder;
	}

	@Autowired
	public void setTemplate(SimpMessagingTemplate template) {
		this.template = template;
	}

	@Override
	public CompletableFuture<User> create(User user) {
		Assert.hasLength(user.getUsername());
		Assert.hasLength(user.getPassword());
		Assert.isTrue(userRepository.count("username", user.getUsername()) == 0, "User " + user.getUsername() + " already exists!");
		user.setPassword(passwordEncoder.encodePassword(user.getPassword(), null));
		CompletableFuture<User> futureUser = userRepository.insert(user);
		futureUser.thenAccept(createdUser -> template.convertAndSend(Topic.USER_CREATED, createdUser.withoutPasswordAndRoles()));
		return futureUser;
	}

	@Override
	public CompletableFuture<User> signup(User user) {
		user.setRoles(Arrays.asList("USER"));
		return create(user);
	}

	@Override
	public CompletableFuture<List<User>> getAllUsers() {
		return userRepository.getAll();
	}

	@Override
	public CompletableFuture<User> getByUsername(String username) {
		return userRepository.getOne("username", username);
	}

	@Override
	public Boolean exists(String username) {
		return userRepository.count("username", username) > 0;
	}
}
