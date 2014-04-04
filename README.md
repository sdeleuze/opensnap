# OpenSnap Spring and Dart demo

Sample fullstack (client + server) Dart project.
Based on : Spring Boot and Spring 4 on serverside and Dart and Angular.dart on client side

## How to run it ?

Prerequisites:
* [Java 8](https://jdk8.java.net/download.html)
* [Gradle 1.11+](http://www.gradle.org/)
* [Dart 1.2+](https://www.dartlang.org/)

Build and run OpenSnap:
* git clone https://github.com/sdeleuze/opensnap.git
* cd opensnap-client
* pub get
* cd ../opensnap-server
* gradle build bootRun
* Run Dartium browser (<dart-sdk>/chromium/Chromium) and open the following URL: http://127.0.0.1:8080/index.html

Notes:
* Make sure that Chrome does not run at the same time than Dartium, since it could prevent the webcam to work
* If you want to run the Javascript version:
 * Set client.path = '../opensnap-client/build' in opensnap-server/src/main/resources/application.yml
 * opensnap-client/pub build
 * Open http://127.0.0.1:8080/index.html in Chrome (other browser not supported yet)


## TODO

* Use SockJS instead of plain Websocket
* Implement persistence
* Test and fix CSS on mobile
* Improve UI
* ...

