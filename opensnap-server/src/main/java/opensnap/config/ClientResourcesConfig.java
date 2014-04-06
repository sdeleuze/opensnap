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

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import java.io.IOException;
import java.nio.file.FileSystem;
import java.nio.file.FileSystems;

@Configuration
@Profile("default")
class ClientResourcesConfig extends WebMvcConfigurerAdapter {

	@Value("${opensnap.client-path:}")
	private String relativePath;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		try {
			FileSystem fs = FileSystems.getDefault();
			String path = fs.getPath(relativePath).toFile().getCanonicalPath();
			registry.addResourceHandler("/**")
					.addResourceLocations("file:" + path + "/")
					.setCachePeriod(0);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
