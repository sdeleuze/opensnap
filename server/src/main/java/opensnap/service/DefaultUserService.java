package opensnap.service;

import opensnap.domain.User;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class DefaultUserService implements UserService {

    private List<User> users;

    public DefaultUserService() {
        users = new ArrayList<User>();
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
    public List<User> getAllUsers() {
		return users.stream().map((u -> u.withoutPassword())).collect(Collectors.toList());
    }

}
