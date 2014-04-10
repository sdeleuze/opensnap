part of opensnap;

class AuthService {
  
  Stream get onEvent => _eventController.stream;
  Http _http;
  UserService _userService;
  StreamController _eventController = new StreamController.broadcast();
  User _authenticatedUser;
  StompClientService _stompClient;
  
  AuthService(this._http, this._userService, this._stompClient);
  
  Future signin(User user) {
    return _stompClient.disconnect().then((_) {
      return _http.post('${window.location.origin}/login', 'username=${user.username}&password=${user.password}',
        headers: { 'Content-Type' : 'application/x-www-form-urlencoded'}).then((HttpResponse response) {
          return _userService.getAuthenticatedUser().then((User u) {
            _eventController.add(new UserEvent(UserEvent.LOGIN, u));
            _authenticatedUser = u;
          });
        });
    });
  }
  
  Future signout() {
    return _http.post('${window.location.origin}//logout', '').then((HttpResponse response) {
      _eventController.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
      _authenticatedUser = null;
      return true;
    }).then((_) {
      _stompClient.disconnect();
    });
  }
  
  User get authenticatedUser => _authenticatedUser;
  
}