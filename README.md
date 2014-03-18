# OpenSnap Spring and Dart demo

Sample fullstack (client + server) Dart project.
Based on : Spring Boot and Spring 4 on serverside and Dart and Angular.dart on client side

## How to run it ?

Build and install opensnap branch of sdeleuze/spring-framework:
* git clone https://github.com/sdeleuze/spring-framework.git
* cd spring-framework
* git checkout opensnap
* ./gradlew build install

Build and run OpenSnap:
* git clone https://github.com/sdeleuze/opensnap.git
* Server : run "gradle build bootRun" from server directory
* Client : open client directory in the Dart Editor and run index.html
* The application should run in Dartium at the following URL : http://127.0.0.1:3030/client/web/index.html
* Make sure that Chrome does not run at the same time than Dartium, since it could prevent the webcam to work

## TODO

* Use SockJS instead of plain Websocket
* Implement persistence
* Test and fix CSS on mobile
* Improve UI
* ...

