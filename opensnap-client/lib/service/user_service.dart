part of opensnap;

class UserService {
  
  List<User> get users => _users;
  Stream get onEvent => _eventController.stream;
  int get createdUserCount => _createdUserCount;
  User get authenticatedUser => _authenticatedUser;
  bool get isAuthenticated => _authenticatedUser != null;
  
  StompClientService _client;
  StreamController _eventController = new StreamController.broadcast();
  Http _http;
  User _authenticatedUser;
  int _createdUserCount = 0;
  List<User> _users = new List();

  UserService(this._client, this._http) {
    onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) return _client._connectIfNeeded().then((_) {
        _client.subscribeJson("/topic/user-created", (var headers, var message) {
          User user = new User.fromJsonMap(message);
            _createdUserCount++;
            _users.add(user);
            _eventController.add(new UserEvent(UserEvent.CREATED, user));
        });
        getAllUsers().then((List<User> users) {
          _users = users;
        });
      });  
    });
    _client.onEvent.listen((StompClientEvent event) {
      if(event.type == StompClientEvent.DISCONNECTED) {
        _eventController.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
        _authenticatedUser = null;
      }
    });
  }

  Future<User> getAuthenticatedUser() {
    return _client.sendJsonSubscribe("/app/usr/authenticated", (_) => new User.fromJsonMap(_));
  }

  Future<List<User>> getAllUsers() {
    return _client.sendJsonSubscribe("/app/usr/all");
  }
  
  Future signin(User user) {
      return signout().then((_) => _http.post('${window.location.origin}/login', 'username=${user.username}&password=${user.password}',
        headers: { 'Content-Type' : 'application/x-www-form-urlencoded'}).then((HttpResponse response) {
          return getAuthenticatedUser().then((User u) {
            _authenticatedUser = u;
            _eventController.add(new UserEvent(UserEvent.LOGIN, u));
          });
        }));
    }
    
    Future<User> signup(User user) {
      return signout().then((_) => _client.sendJsonMessage("/app/usr/signup", user, "/user/queue/user-created", (_) => new User.fromJsonMap(_)))
          .then((User u) => signout()).catchError((_) => signout());
    }
    
    Future signout() {
      return _http.post('${window.location.origin}/logout', '').then((HttpResponse response) {
        _eventController.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
        _authenticatedUser = null;
      }).then((_) {
        _client.disconnect();
      });
    }
    
}