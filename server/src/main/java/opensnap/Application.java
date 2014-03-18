package opensnap;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableAutoConfiguration
@ComponentScan(basePackages = "opensnap")
public class Application extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(new Object[]{Application.class}, args);
    }
	
}
