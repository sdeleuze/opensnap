part of opensnap;

class AuthService {
  
  Stream get onEvent => _eventController.stream;
  Http _http;
  UserService _userService;
  StreamController _eventController = new StreamController.broadcast();
  User _authenticatedUser;
  
  AuthService(this._http, this._userService);
  
  Future<bool> signin(User user) {
    return _http.post('http://$SERVER_HOST/login', 'username=${user.username}&password=${user.password}',
        headers: { 'Content-Type' : 'application/x-www-form-urlencoded'}
    ).then((HttpResponse response) {
      return _userService.getAuthenticatedUser().then((User u) {
        _eventController.add(new UserEvent(UserEvent.LOGIN, u));
        _authenticatedUser = u;
        return true;
      });
       
    }, onError: (_)  => false);
  }
  
  Future<bool> signout() {
    return _http.post('http://$SERVER_HOST/logout', '').then((HttpResponse response) {
      _eventController.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
      _authenticatedUser = null;
      return true;
    }, onError: (_) => false);
  }
  
  User get authenticatedUser => _authenticatedUser;
  
}