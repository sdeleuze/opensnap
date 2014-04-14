part of opensnap;

class UserService {

  List<User> get users => _users;

  Stream get onEvent => _events.stream;

  int get createdUserCount => _createdUserCount;

  User get authenticatedUser => _authenticatedUser;

  bool get isAuthenticated => _authenticatedUser != null;

  StompClientService _client;
  StreamController _events = new StreamController.broadcast();
  Http _http;
  User _authenticatedUser;
  int _createdUserCount = 0;
  List<User> _users = new List();

  UserService(this._client, this._http) {
    onEvent.listen((UserEvent event) {
      if (event.type == UserEvent.LOGIN) {
        _client.jsonSubscribe("/topic/user-created", (_) {
          User user = new User.fromJsonMap(_);
          _createdUserCount++;
          _users.add(user);
          _events.add(new UserEvent(UserEvent.CREATED, user));
        });
        getAllUsers().then((List<User> users) {
          _users = users;
        });
      }
    });
    _client.onEvent.listen((StompClientEvent event) {
      if (event.type == StompClientEvent.DISCONNECTED) {
        _events.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
        _authenticatedUser = null;
      }
    });
  }

  Future<User> getAuthenticatedUser() {
    return _client.jsonSubscribeRequest("/app/usr/authenticated", (_) => new User.fromJsonMap(_));
  }

  Future<List<User>> getAllUsers() {
    return _client.jsonSubscribeRequest("/app/usr/all");
  }

  Future signin(User user) {
    return signout().then((_) => _http.post('${window.location.origin}/login', 'username=${user.username}&password=${user.password}', headers: {
        'Content-Type' : 'application/x-www-form-urlencoded'
    }).then((HttpResponse response) => _client.connectWebsocket().then((_) => getAuthenticatedUser().then((User u) {
      _authenticatedUser = u;
      _events.add(new UserEvent(UserEvent.LOGIN, u));
    }))));
  }

  Future<User> signup(User user) {
    return signout().then((_) => _client.connectWebsocket()).then((_) => _client.jsonMessageRequest("/app/usr/signup", user, "/user/queue/user-created", (_) => new User.fromJsonMap(_))).then((User u) => signout()).catchError((_) => signout());
  }

  Future signout() {
    return _http.post('${window.location.origin}/logout', '').then((HttpResponse response) {
      _events.add(new UserEvent(UserEvent.LOGOUT, _authenticatedUser));
      _authenticatedUser = null;
    }).then((_) {
      _client.disconnect();
    });
  }

}