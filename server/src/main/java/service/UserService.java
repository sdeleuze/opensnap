package service;

import domain.User;

import java.util.List;

public interface UserService {
    public Boolean authenticate(User user);
    public List<User> getAllUsers();
}
