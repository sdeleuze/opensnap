package opensnap.service;

import opensnap.domain.User;

import java.util.Set;

public interface UserService {
	User create(User user);
	User signup(User user);
	Boolean authenticate(User user);
	User getByUsername(String username);
	Set<User> getAllUsers();
}
