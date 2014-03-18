package web;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import domain.User;
import service.UserService;

import java.util.ArrayList;
import java.util.List;

@Controller
@MessageMapping("/usr")
public class UserController {

    @Autowired
    private UserService userService;

    public UserController() {

    }

	@MessageMapping("/auth")
    Boolean authenticate(User user) {
        return userService.authenticate(user);
    }

	@MessageMapping
    List<User> getUsers() {
        return userService.getAllUsers();
    }

}