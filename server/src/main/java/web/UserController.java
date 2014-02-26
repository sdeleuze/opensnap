package web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import domain.User;
import service.UserService;

import java.util.ArrayList;
import java.util.List;

@RestController @RequestMapping("/api/user")
public class UserController {

    @Autowired
    private UserService userService;

    public UserController() {

    }

    @RequestMapping(method = RequestMethod.POST, value = "auth")
    Boolean authenticate(@RequestBody User user) {
        return userService.authenticate(user);
    }

    @RequestMapping
    List<User> getUsers() {
        return userService.getAllUsers();
    }

}