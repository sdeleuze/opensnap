package opensnap.service;

import opensnap.*;
import opensnap.domain.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.*;

@Service
public class DefaultUserService implements UserService {

	private List<User> users;
	private SimpMessagingTemplate template;
	private PasswordEncoder passwordEncoder;

	@Autowired
	public DefaultUserService(PasswordEncoder passwordEncoder) {
		users = Collections.synchronizedList(new ArrayList<User>());
		this.passwordEncoder = passwordEncoder;
	}

	@Autowired
	public void setTemplate(SimpMessagingTemplate template) {
		this.template = template;
	}

	@Override
	public User create(User user) {
		Assert.hasLength(user.getUsername());
		Assert.hasLength(user.getPassword());
		Assert.isTrue(users.stream().noneMatch((u) -> u.getUsername().equals(user.getUsername())), "User " + user.getUsername() + " already exists!");
		user.setPassword(passwordEncoder.encodePassword(user.getPassword(), null));
		users.add(user);
		template.convertAndSend(Topic.USER_CREATED, user.withoutPasswordAndRoles());
		return user;
	}

	@Override
	public User signup(User user) {
		user.setRoles(Arrays.asList("USER"));
		return create(user);
	}

	@Override
	public Boolean authenticate(User user) {
		return users.contains(user);
	}

	@Override
	public List<User> getAllUsers() {
		return users;
	}

	@Override
	public User getByUsername(String username) {
		synchronized (users) {
			return users.stream().filter((s) -> s.getUsername().equals(username)).findFirst()
					.orElseThrow(() -> new IllegalArgumentException("No user with username " + username + " found!"));
		}
	}

}
