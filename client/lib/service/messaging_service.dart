import 'auth_service.dart';
import "package:stomp/stomp.dart";
import "package:stomp/websocket.dart" show connect;

class MessagingService {
  
  AuthService _authService;
  
  MessagingService(this._authService) {
    
    connect("ws://localhost:8080/test").then((StompClient client) {
      client.subscribeString("0", "/topic/toto",
          (Map<String, String> headers, String message) {
        print("Recieve $message");
      });

    client.sendString("/app/test", "OpenSnap");
  });
    
  }
}

