package opensnap;

import opensnap.config.ContainerConfig;
import opensnap.web.SimpleCORSFilter;
import org.apache.catalina.connector.Connector;
import org.apache.coyote.http11.Http11NioProtocol;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.context.embedded.EmbeddedServletContainerFactory;
import org.springframework.boot.context.embedded.FilterRegistrationBean;
import org.springframework.boot.context.embedded.tomcat.TomcatEmbeddedServletContainerFactory;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import java.io.File;
import java.io.IOException;

@Configuration
@EnableAutoConfiguration
@ComponentScan(basePackages = "opensnap")
public class Application extends SpringBootServletInitializer {

	public static void main(String[] args) {
		SpringApplication.run(new Object[]{Application.class}, args);
	}

	@Bean
	public FilterRegistrationBean corsFilter() {
		FilterRegistrationBean filterRegistration = new FilterRegistrationBean();
		filterRegistration.setFilter(new SimpleCORSFilter());
		filterRegistration.setOrder(0);
		return filterRegistration;
	}

	@Bean
	public ContainerConfig containerConfig() {
		return new ContainerConfig();
	}

	@Bean
	public EmbeddedServletContainerFactory servletContainer() {
		TomcatEmbeddedServletContainerFactory tomcat = new TomcatEmbeddedServletContainerFactory();
		tomcat.addAdditionalTomcatConnectors(createSslConnector());
		return tomcat;
	}

	private Connector createSslConnector() {
		Connector connector = new Connector("org.apache.coyote.http11.Http11NioProtocol");
		Http11NioProtocol protocol = (Http11NioProtocol) connector.getProtocolHandler();
		try {
			File keystore = new ClassPathResource("keystore").getFile();
			File truststore = new ClassPathResource("keystore").getFile();
			connector.setScheme("https");
			connector.setSecure(true);
			connector.setPort(8443);
			protocol.setSSLEnabled(true);
			protocol.setKeystoreFile(keystore.getAbsolutePath());
			protocol.setKeystorePass("opensnap");
			protocol.setTruststoreFile(truststore.getAbsolutePath());
			protocol.setTruststorePass("opensnap");
			protocol.setKeyAlias("tomcat");
			return connector;
		}
		catch (IOException ex) {
			throw new IllegalStateException("can't access keystore: [" + "keystore"
					+ "] or truststore: [" + "keystore" + "]", ex);
		}
	}

}
