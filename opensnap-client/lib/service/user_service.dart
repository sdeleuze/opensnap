part of opensnap;

class UserService {

  StompClientService _client;
  StreamController _evenController = new StreamController.broadcast();
  Stream get onEvent => _eventController.stream;
  Http _http;
  StreamController _eventController = new StreamController.broadcast();
  User _authenticatedUser;

  UserService(this._client, this._http) {
    _client.onEvent.listen((StompClientEvent event) {
          if(event.type == StompClientEvent.CONNECTED && this.isAuthenticated) return _client._connectIfNeeded().then((_) {
            _client.subscribeJson("/topic/user-created", (var headers, var message) {
                _evenController.add(new UserEvent(UserEvent.CREATED, new User.fromJsonMap(message)));
              });
            });  
        });
  }

  Future<User> getAuthenticatedUser() {
    return _client.sendJsonSubscribe("/app/usr/authenticated", (_) => new User.fromJsonMap(_));
  }

  Future<List<User>> getAllUsers() {
    return _client.sendJsonSubscribe("/app/usr/all");
  }
  
  Future signin(User user) {
      return _http.post('${window.location.origin}/login', 'username=${user.username}&password=${user.password}',
        headers: { 'Content-Type' : 'application/x-www-form-urlencoded'}).then((HttpResponse response) {
          // User without the roles
          _authenticatedUser = user;
          return getAuthenticatedUser().then((User u) {
            _authenticatedUser = u;
            _eventController.add(new UserEvent(UserEvent.LOGIN, u));
          });
        });
    }
    
    Future<User> signup(User user) {
      return signout().then((_) => _client.sendJsonMessage("/app/usr/signup", user, "/user/queue/user-created", (_) => new User.fromJsonMap(_)))
          .then((User u) => signout()).catchError((_) => signout());
    }
    
    Future signout() {
      return _http.post('${window.location.origin}/logout', '').then((HttpResponse response) {
        _eventController.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
        _authenticatedUser = null;
        return true;
      }).then((_) {
        _client.disconnect();
      });
    }
    
    User get authenticatedUser => _authenticatedUser;
    bool get isAuthenticated => _authenticatedUser != null;

}