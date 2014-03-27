package opensnap.service;

import opensnap.domain.User;

import java.util.List;

public interface UserService {
	User create(User user);
    Boolean authenticate(User user);
	User getByUsername(String username);
    List<User> getAllUsers();
}
