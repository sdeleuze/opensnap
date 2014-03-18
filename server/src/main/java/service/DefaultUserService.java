package service;

import domain.User;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class DefaultUserService implements UserService {

    private List<User> users;

    public DefaultUserService() {
        users = new ArrayList<User>();
        users.add(new User("eric","3r1c"));
        users.add(new User("adeline","ad3l1n3"));
        users.add(new User("johanna","j0hanna"));
        users.add(new User("michel","m1ch3l"));
    }

    public Boolean authenticate(User user) {
        return users.contains(user);
    }

    public List<User> getAllUsers() {
		return users.stream().map((u -> u.withoutPassword())).collect(Collectors.toList());
    }

}
