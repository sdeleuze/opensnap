package opensnap.service;

import opensnap.domain.User;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;

@Service
public class DataInitializer implements InitializingBean {

	private final UserService userService;

	@Autowired
	public DataInitializer(UserService userService) {
		this.userService = userService;
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		this.userService.create(new User("eric", "3r1c", Arrays.asList("USER")));
		this.userService.create(new User("adeline", "ad3l1n3", Arrays.asList("USER")));
		this.userService.create(new User("johanna", "j0hanna", Arrays.asList("USER")));
		this.userService.create(new User("michel", "m1ch3l", Arrays.asList("USER", "ADMIN")));
	}

}
