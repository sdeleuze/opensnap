part of opensnap;

class AuthService {
  
  Stream get onEvent => eventController.stream;
  Http _http;
  UserService _userService;
  StreamController eventController = new StreamController.broadcast();
  User authenticatedUser;
  
  AuthService(this._http, this._userService);
  
  Future signin(User user) {
    return new Future.value(true);
  }
  
  Future signout() {
    return new Future.value(true);
  }
 
  
}