part of opensnap;

class AuthService {
  
  Stream get onEvent => _eventController.stream;
  Http _http;
  StreamController _eventController = new StreamController.broadcast();
  User _authenticatedUser;
  
  AuthService(this._http);
  
  Future<bool> signin(User user) {
    return _http.post('http://$SERVER_HOST/login', 'username=${user.username}&password=${user.password}',
        headers: { 'Content-Type' : 'application/x-www-form-urlencoded'}
    ).then((HttpResponse response) {
      _eventController.add(new UserEvent(UserEvent.LOGIN, user));
      _authenticatedUser = user;
      return true;
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