package web;

import org.springframework.web.bind.annotation.*;

@RestController
public class HelloController {

    @RequestMapping("/hello")
    String home() {
        return "Hello World!!";
    }

}