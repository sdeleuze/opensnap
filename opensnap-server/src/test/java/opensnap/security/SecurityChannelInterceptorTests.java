/*
 * Copyright 2002-2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package opensnap.security;

import opensnap.domain.User;
import opensnap.service.UserService;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.testng.annotations.BeforeTest;
import org.testng.annotations.Test;

import java.util.Arrays;
import java.util.concurrent.CompletableFuture;

import static org.fest.assertions.api.Assertions.*;
import static org.mockito.Mockito.when;

public class SecurityChannelInterceptorTests {

	private SecurityChannelInterceptor interceptor;

	@Mock
	private UserService userService;

	@BeforeTest
	public void setup() {
		MockitoAnnotations.initMocks(this);
		CompletableFuture<User> eric = new CompletableFuture<>();
		eric.complete(new User("eric", "3r1c", Arrays.asList("USER")));
		when(userService.getByUsername("eric")).thenReturn(eric);
		CompletableFuture<User> michel = new CompletableFuture<>();
		michel.complete(new User("michel", "m1ch3l", Arrays.asList("USER", "ADMIN")));
		when(userService.getByUsername("michel")).thenReturn(michel);
		this.interceptor = new SecurityChannelInterceptor(this.userService);
		this.interceptor.loadConfiguration("test-security.yml");
	}

	@Test
	public void testIsAllowed() {
		assertThat(this.interceptor.isAllowed("/app/test", "eric")).isTrue();
		assertThat(this.interceptor.isAllowed("/app/admin", "eric")).isFalse();
		assertThat(this.interceptor.isAllowed("/topic/user", "eric")).isTrue();
		assertThat(this.interceptor.isAllowed("/topic/admin", "eric")).isFalse();
		assertThat(this.interceptor.isAllowed("/topic/user-admin", "eric")).isTrue();
		assertThat(this.interceptor.isAllowed("/queue", "eric")).isFalse();
		assertThat(this.interceptor.isAllowed("/app/test", "michel")).isTrue();
		assertThat(this.interceptor.isAllowed("/app/admin", "michel")).isTrue();
		assertThat(this.interceptor.isAllowed("/topic/user", "michel")).isTrue();
		assertThat(this.interceptor.isAllowed("/topic/admin", "michel")).isTrue();
		assertThat(this.interceptor.isAllowed("/topic/user-admin", "michel")).isTrue();
		assertThat(this.interceptor.isAllowed("/queue", "michel")).isFalse();
		assertThat(this.interceptor.isAllowed("/app/test", "paul")).isFalse();
		assertThat(this.interceptor.isAllowed("/app/admin", "paul")).isFalse();
		assertThat(this.interceptor.isAllowed("/topic/user", "paul")).isFalse();
		assertThat(this.interceptor.isAllowed("/topic/admin", "paul")).isFalse();
		assertThat(this.interceptor.isAllowed("/topic/user-admin", "paul")).isFalse();
		assertThat(this.interceptor.isAllowed("/queue", "paul")).isFalse();
	}
}
