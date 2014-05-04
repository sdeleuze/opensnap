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

package opensnap.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import opensnap.security.SecurityChannelInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.converter.MessageConverter;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.config.StompBrokerRelayRegistration;
import org.springframework.web.socket.config.annotation.AbstractWebSocketMessageBrokerConfigurer;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketTransportRegistration;

import java.util.List;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig extends AbstractWebSocketMessageBrokerConfigurer {

	private SecurityChannelInterceptor interceptor;

	private ObjectMapper mapper;

	@Value("${broker.enabled}")
	private boolean brokerEnabled;

	@Value("${broker.login}")
	private String brokerLogin;

	@Value("${broker.password}")
	private String brokerPassword;

	@Value("${broker.host}")
	private String brokerHost;

	@Value("${broker.port}")
	private int brokerPort;

	@Value("${broker.virtual-host}")
	private String brokerVirtualHost;


	@Autowired
	public void setInterceptor(SecurityChannelInterceptor interceptor) {
		this.interceptor = interceptor;
	}

	@Autowired
	public void setMapper(ObjectMapper mapper) {
		this.mapper = mapper;
	}

	@Override
	public void configureWebSocketTransport(WebSocketTransportRegistration registration) {
		registration.setMessageSizeLimit(1024 * 1024);
	}

	@Override
	public void configureClientInboundChannel(ChannelRegistration registration) {
		this.interceptor.loadConfiguration("security.yml");
		registration.setInterceptors(this.interceptor).taskExecutor().corePoolSize(1).maxPoolSize(1);
	}



	@Override
	public void configureClientOutboundChannel(ChannelRegistration registration) {
		registration.taskExecutor().corePoolSize(1).maxPoolSize(1);
	}

	@Override
	public void configureMessageBroker(MessageBrokerRegistry config) {
		config.setApplicationDestinationPrefixes("/app");
		if(brokerEnabled) {
			StompBrokerRelayRegistration brokerRegistration = config.enableStompBrokerRelay("/queue", "/topic")
					.setSystemLogin(brokerLogin).setSystemPasscode(brokerPassword).setClientLogin(brokerLogin)
				  	.setClientPasscode(brokerPassword).setRelayHost(brokerHost).setRelayPort(brokerPort);
			if(!brokerVirtualHost.equals("")) {
				brokerRegistration.setVirtualHost(brokerVirtualHost);
			}
		} else {
			config.enableSimpleBroker("/queue", "/topic");
		}
	}

	@Override
	public void registerStompEndpoints(StompEndpointRegistry registry) {
		registry.addEndpoint("/websocket").setHandshakeHandler(new CustomHandshakeHandler());
	}

	@Override
	public boolean configureMessageConverters(List<MessageConverter> messageConverters) {
		MappingJackson2MessageConverter converter = new MappingJackson2MessageConverter();
		converter.setObjectMapper(mapper);
		messageConverters.add(converter);
		return false;
	}
}
