import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.client.standard.StandardWebSocketClient;
import service.DefaultSnapService;
import service.DefaultUserService;
import service.SnapService;
import service.UserService;
import web.*;

import javax.servlet.Filter;
import javax.websocket.ContainerProvider;

@Configuration @EnableAutoConfiguration
public class Application extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(Application.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(new Object[]{Application.class, WebSocketConfig.class}, args);
    }

    @Bean
    public StandardWebSocketClient client() {
        return new StandardWebSocketClient();
    }

    @Bean
    public SnapService snapService() {
        return new DefaultSnapService();
    }

    @Bean
    public UserService userService() {
        return new DefaultUserService();
    }

    @Bean
    public Filter simpleCorsFilter() {
        return new SimpleCORSFilter();
    }

    @Bean
    public SnapController snapController() {
        return new SnapController();
    }

    @Bean
    public UserController userController() {
        return new UserController();
    }
	
}
