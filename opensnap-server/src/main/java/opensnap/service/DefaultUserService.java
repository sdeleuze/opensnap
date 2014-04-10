package opensnap.service;

import opensnap.domain.User;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.*;

@Service
public class DefaultUserService implements UserService {

	private Set<User> users;

	public DefaultUserService() {
		users = Collections.synchronizedSet(new LinkedHashSet<User>());
	}

	@Override
	public User create(User user) {
		Assert.hasLength(user.getUsername());
		Assert.hasLength(user.getPassword());
		users.add(user);
		return user;
	}

	@Override
	public Boolean authenticate(User user) {
		return users.contains(user);
	}

	@Override
	public Set<User> getAllUsers() {
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
