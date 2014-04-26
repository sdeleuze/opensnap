package opensnap;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import opensnap.domain.User;
import opensnap.service.UserService;

import org.mongodb.MongoClient;
import org.mongodb.MongoClients;
import org.mongodb.MongoDatabase;
import org.mongodb.connection.ServerAddress;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;

import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;

import java.util.Arrays;

@Configuration
@EnableAutoConfiguration
@ComponentScan(basePackages = "opensnap")
public class Application extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(new Object[]{Application.class}, args);
	}

	@Bean
	public InitializingBean populateTestData(UserService userService) {
		return () -> {
			if(!userService.exists("anonymous")) {
				userService.create(new User("anonymous", "jdqsjkdjsqkjd", Arrays.asList("ANONYMOUS")));
				userService.create(new User("seb", "s3b", Arrays.asList("USER", "ADMIN")));
				userService.create(new User("adeline", "ad3l1n3", Arrays.asList("USER")));
				userService.create(new User("johanna", "j0hanna", Arrays.asList("USER")));
				userService.create(new User("michel", "m1ch3l", Arrays.asList("USER")));
			}
		};
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new ShaPasswordEncoder(256);
	}

	@Bean
	public MongoClient mongoClient() {
		return MongoClients.create(new ServerAddress());
	}

	@Bean
	public MongoDatabase mongoDatabase(MongoClient mongoClient) {
		return mongoClient.getDatabase("opensnap");
	}

	@Bean
	public ObjectMapper objectMapper() {
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);

		return objectMapper;
	}

}
