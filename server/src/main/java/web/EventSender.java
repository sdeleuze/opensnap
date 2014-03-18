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

package web;

import domain.SnapPublishedEvent;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

/**
 * @author Sebastien Deleuze
 * @since 4.1
 */
@Component
public class EventSender implements ApplicationListener<SnapPublishedEvent> {

	private SimpMessagingTemplate template;

	@Autowired
	public void setTemplate(SimpMessagingTemplate template) {
		this.template = template;
	}

	@Override
	public void onApplicationEvent(SnapPublishedEvent event) {
		template.convertAndSendToUser(event.getSnap().getRecipient().getUsername(), "/queue/published", new Integer(event.getSnap().getId()));
	}
}
