import 'dart:html';
import 'auth_service.dart';

class MessagingService {
  
  AuthService _authService;
  
  MessagingService(this._authService) {
    
    // Just to test Websocket connection, but the real target is to use STOMP messaging over Websocket
    WebSocket ws = new WebSocket("ws://localhost:8080/echo/websocket");
    ws.onOpen.listen((Event e) {
      ws.send("toto");
    });
    ws.onMessage.listen((MessageEvent e) {
      print(e.data);
    });
    
  }
}

