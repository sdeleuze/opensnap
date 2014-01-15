library events_service;

import 'dart:async';
import '../domain.dart';

class AuthService {
  
  StreamController _onSigninController = new StreamController.broadcast();
  StreamController _onSignoutController = new StreamController.broadcast();
  User authenticatedUser;
  
  void signin(User user) {
    _onSigninController.add(user); // send an arbitrary event
    authenticatedUser = user;
  }
  
  void signout(User user) {
    _onSignoutController.add(user); // send an arbitrary event
    authenticatedUser = null;
  }
  
  Stream get onSignin => _onSigninController.stream;
  Stream get onSignout => _onSignoutController.stream;
  
}