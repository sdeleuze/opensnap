library query_service;

import 'dart:async';
import 'package:angular/angular.dart';
import '../domain.dart';

class QueryService {
  
  String _userUrl = 'http://localhost:8080/api/user';
  String _snapUrl = 'http://localhost:8080/api/snap';
  Http _http;
  
  QueryService(this._http) {
    
  }
  
  Future<bool> authenticateUser(User user) {
    return _http.post('$_userUrl/auth', user.toJsonString()).then((HttpResponse response) {
      bool status = response.data == 'true';
      return status;
    });
  }
  
  Future<List<User>> getAllUsers() {
    return _http.get('$_userUrl').then((HttpResponse response) {
      List<User> users = new List<User>();
      for(Map map in response.data) {
        users.add(new User.fromJsonMap(map));  
      }
      return users;
      
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return _http.post('$_snapUrl', snap.toJsonString()).then((HttpResponse response) {
      return new Snap.fromJsonMap(response.data);
    });
  }
  
  Future<List<Snap>> getSnapsFromUsername(String username) {
    return _http.get('$_snapUrl/$username').then((HttpResponse response) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in response.data) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      return snaps;
      
    });
  }
  
  void deleteSnap(int id) {
    _http.delete('$_snapUrl/$id');
  }
  
}