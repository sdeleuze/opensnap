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

import org.apache.catalina.connector.Connector;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.embedded.ConfigurableEmbeddedServletContainer;
import org.springframework.boot.context.embedded.EmbeddedServletContainerCustomizer;
import org.springframework.boot.context.embedded.tomcat.TomcatConnectorCustomizer;
import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.Channels;
import java.nio.channels.FileChannel;
import java.nio.channels.ReadableByteChannel;

@Configuration
public class ContainerConfig implements EmbeddedServletContainerCustomizer {

	@Value("${server.port:8080}")
	private int port;

	@Value("${opensnap.https:false}")
	private boolean https;

	@Override
	public void customize(ConfigurableEmbeddedServletContainer container) {

		if(container instanceof TomcatEmbeddedServletContainerFactory) {
			customizeTomcat((TomcatEmbeddedServletContainerFactory) container);
		}
	}

	void customizeTomcat(TomcatEmbeddedServletContainerFactory factory) {
		// Just for dev mode, in order to access to Dart packages symlinks
		factory.addContextCustomizers((context) -> {
			context.addMimeMapping("dart", "application/dart");
		});
		if(https) {
			enableHttps(factory);
		}
		enableCompression(factory);
	}

	public void enableHttps(TomcatEmbeddedServletContainerFactory factory) {
		factory.addConnectorCustomizers(new TomcatConnectorCustomizer() {
			@Override
			public void customize(Connector connector) {
				connector.setPort(port);
				connector.setSecure(true);
				connector.setScheme("https");
				connector.setAttribute("keyAlias", "tomcat");
				connector.setAttribute("keystorePass", "opensnap");
				try {
					ClassPathResource keystoreResource = new ClassPathResource("keystore");
					ReadableByteChannel source = Channels.newChannel(keystoreResource.getInputStream());
					File keystoreFile = File.createTempFile("tomcat", ".keystore");
					FileChannel destination = new FileOutputStream(keystoreFile).getChannel();
					destination.transferFrom(source, 0, keystoreResource.contentLength());
					destination.close();

					connector.setAttribute("keystoreFile", keystoreFile.getAbsolutePath());
				} catch (IOException e) {
					throw new IllegalStateException("Cannot load keystore", e);
				}
				connector.setAttribute("clientAuth", "false");
				connector.setAttribute("sslProtocol", "TLS");
				connector.setAttribute("SSLEnabled", true);
			}
		});
	}

	public void enableCompression(TomcatEmbeddedServletContainerFactory factory) {
		factory.addConnectorCustomizers(new TomcatConnectorCustomizer() {
			@Override
			public void customize(Connector connector) {
				connector.setProperty("compression", "on");
				connector.setProperty("compressionMinSize", "2048");
				connector.setProperty("compressableMimeType", "text/html,text/css,application/javascript,application/dart");
			}
		});
	}

}
