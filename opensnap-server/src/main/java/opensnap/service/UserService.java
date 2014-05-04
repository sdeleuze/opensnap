package opensnap.service;

import opensnap.domain.User;

import java.util.List;
import java.util.concurrent.CompletableFuture;

public interface UserService {
	CompletableFuture<User> create(User user);
	CompletableFuture<User> signup(User user);
	CompletableFuture<Boolean> exists(String username);
	CompletableFuture<User> getByUsername(String username);
	CompletableFuture<List<User>> getAllUsers();
}
