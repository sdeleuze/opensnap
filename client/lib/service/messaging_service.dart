library query_service;

import 'dart:async';
import '../domain.dart';
import 'auth_service.dart';
import "package:stomp/stomp.dart";
import "package:stomp/websocket.dart" show connect;

class MessagingService {

  StompClient _stompClient;
  String url, login, passcode;
  AuthService _authService;
  int _connexionId = 0;
  
  MessagingService(this.url, this._authService, [this.login, this.passcode]) {
    if(this._authService.authenticatedUser != null) {
      this.login = this._authService.authenticatedUser.username;
      this.passcode = this._authService.authenticatedUser.password;
    }
    this._authService.onSignin.listen((User user) {
      this.login = user.username;
      this.passcode = user.password;
    });
  }
  
  Future<StompClient> _connectIfNeeded() {
    if(_stompClient == null) {
      assert(login != null);
      assert(passcode != null);
      return connect(url, login:login, passcode:passcode).then((StompClient client) {
        _stompClient = client;
      });
    }
    return new Future<StompClient>.value(_stompClient);
  }
  
  Future sendJson(String destination, [var object = null, var convert = null]) {
    return this._connectIfNeeded().then((_) {
      var completer = new Completer();
      String id = (_connexionId++).toString();
      _stompClient.subscribeJson(id, "/topic${destination}", (Map<String, String> headers, var message) {
        if(convert == null) {
          completer.complete(message);
        } else {
          completer.complete(convert(message));
        }
        _stompClient.unsubscribe(id);
      });
      var json = (object == null) ? {} : (object is String || object is int) ? object : object.toJson();
      _stompClient.sendJson("/app${destination}", json);
      return completer.future;
    });
  }
  
  Future sendString(String destination, [String value = ""]) {
    return this._connectIfNeeded().then((_) {
      var completer = new Completer();
      String id = (_connexionId++).toString();
      _stompClient.subscribeJson(id, "/topic${destination}", (Map<String, String> headers, var message) {
        completer.complete(message);
        _stompClient.unsubscribe(id);
      });
      _stompClient.sendString("/app${destination}", value);
      return completer.future;
    });
  }
}

class UserService extends MessagingService {
  
  UserService(AuthService authService) : super("ws://localhost:8080/opensnap", authService);
  
  Future<bool> authenticateUser(User user) {
    this.login = user.username;
    this.passcode = user.password;
    Future<bool> future = sendJson("/usr/auth", user);
    future.then((status) {
      if(status) {
        this._authService.signin(user);
      }
    });
    return future;
  }
    
  Future<List<User>> getAllUsers() {
    return sendJson("/usr");
  }
  
}

class SnapService extends MessagingService {
  
  StreamController _onPublishedController = new StreamController.broadcast();
  StreamController _onSnapsRetreivedController = new StreamController.broadcast();
  
  SnapService(AuthService authService) : super("ws://localhost:8080/opensnap", authService) {
    this._authService.onSignin.listen((_) {
      String id = (_connexionId++).toString();
      this._connectIfNeeded().then((_) {
        _stompClient.subscribeString(id, "/user/queue/published", (Map<String, String> headers, String id) {
            _onPublishedController.add(int.parse(id));
         });
      });
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return sendJson("/snap/create", snap, (_) => new Snap.fromJsonMap(_));
  }
  
  Future<Snap> getSnapById(int id) {
      return sendJson("/snap/$id", null, (_) => new Snap.fromJsonMap(_));
    }
    
  Future<List<Snap>> getSnapsFromUsername(String username) {
    return sendJson("/snap", username, (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      _onSnapsRetreivedController.add(snaps);
      return snaps;
    });
  }
      
  void deleteSnap(int id, String username) {
      sendJson('/snap/delete/$id/$username');
    }
  
  Stream get onSnapPublished => _onPublishedController.stream;
  Stream get onSnapsRetreived => _onSnapsRetreivedController.stream;
  
}