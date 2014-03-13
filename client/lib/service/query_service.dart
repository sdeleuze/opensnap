library query_service;

import 'dart:async';
import '../domain.dart';
import "package:stomp/stomp.dart";
import "package:stomp/websocket.dart" show connect;

class StompQueryService {

  StompClient _stompClient;
  int connexionId = 0;
  
  StompQueryService(String url) {
    connect(url).then((StompClient client) {
      _stompClient = client;
    });
  }
  
  Future sendJson(String destination, [var object = null, var convert = null]) {
    var completer = new Completer();
    String id = (connexionId++).toString();
    _stompClient.subscribeJson(id, "/topic${destination}", (Map<String, String> headers, var message) {
      if(convert == null) {
        completer.complete(message);
      } else {
        completer.complete(convert(message));
      }
      _stompClient.unsubscribe(id);
    });
    var json = (object == null) ? {} : object is String ? object : object.toJson();
    _stompClient.sendJson("/app${destination}", json);
    return completer.future;
  }
  
  Future sendString(String destination, [String value = ""]) {
      var completer = new Completer();
      String id = (connexionId++).toString();
      _stompClient.subscribeJson(id, "/topic${destination}", (Map<String, String> headers, var message) {
        completer.complete(message);
        _stompClient.unsubscribe(id);
      });
      _stompClient.sendString("/app${destination}", value);
      return completer.future;
    }
}

class UserQueryService extends StompQueryService {
  
  UserQueryService() : super("ws://localhost:8080/user");
  
  Future<bool> authenticateUser(User user) {
    return sendJson("/user/auth", user);
  }
    
  Future<List<User>> getAllUsers() {
    return sendJson("/user");
  }
  
}

class SnapQueryService extends StompQueryService {
  
  SnapQueryService() : super("ws://localhost:8080/snap");
  
  Future<Snap> createSnap(Snap snap) {
    return sendJson("/snap/create", snap, (_) => new Snap.fromJsonMap(_));
  }
    
  Future<List<Snap>> getSnapsFromUsername(String username) {
    return sendJson("/snap", username, (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      return snaps;
    });
  }
    
  Future deleteSnap(int id) {
      return sendJson('/snap/delete/$id');
    }
  
}