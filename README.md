OpenSnap is a sample reactive application based on:
* Java 8, Spring Framework 4, Spring Boot and asynchronous MongoDB driver on serverside
* Dart and AngularDart on client side

STOMP messages over websocket are used for 2 ways communication between client and server.

Slides of my Devoxx and MixIT talk "Reactive applications with Spring , AngularDart and Websocket"
based on OpenSnap are available on [SpeakerDeck](https://speakerdeck.com/sdeleuze/reactive-applications-with-spring-angulardart-and-websocket).

You can also try the [demo](http://opensnap.io/) (only Chrome supported for now).

## How to run it ?

Prerequisites:
* [Java 8](https://jdk8.java.net/download.html)
* [Gradle](http://www.gradle.org/)
* [Dart 1.2+](https://www.dartlang.org/)
* $PATH should contains dart/dart-sdk/bin and gradle/bin

Build and run OpenSnap:
* git clone https://github.com/sdeleuze/opensnap.git
* ./gradlew build run
* Open the following URL in your browser: http://127.0.0.1:8080/index.html
	* For Dart version, run Dartium browser (<dart-sdk>/chromium/Chromium)
	* For Javascript version, run your usual browser (only Chrome supported for now)

Notes:
* Make sure that Chrome does not run at the same time than Dartium, since it could prevent the webcam to work

## How to contribute ?

Feel free to send pull requests !

My reference development environment is IntelliJ IDEA 13.1 + its Dart plugin.
You should :
 * import OpenSnap as a Gradle project
 * Open OpenSnap module settings and set Java project level to Java 8
 * Enable Dart on opensnap-client module (Preferences -> Dart -> Enable Dart for this project + check opensnap-client module).
 * Ensure that working directory is set to the absolute path of opensnap/opensnap-server and not only opensnap in run application property.

To run server side, just run or debug Application class main method.
For client side, be sure to use http://127.0.0.1:8080 URL in order to avoid cross domain issues