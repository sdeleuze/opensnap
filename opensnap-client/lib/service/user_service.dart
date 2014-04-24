part of opensnap;

@Injectable()
class UserService {

  Stream get onCreated => _createdEvents.stream;
  Stream get onLogin => _loginEvents.stream;
  Stream get onLogout => _logoutEvents.stream;
  
  List<User> get users => _users;
  
  StreamController _createdEvents = new StreamController.broadcast();
  StreamController _loginEvents = new StreamController.broadcast();
  StreamController _logoutEvents = new StreamController.broadcast();

  int get createdUserCount => _createdUserCount;

  User get authenticatedUser => _authenticatedUser;

  bool get isAuthenticated => _authenticatedUser != null;

  StompClientService _client;
  Http _http;
  User _authenticatedUser;
  int _createdUserCount = 0;
  List<User> _users = new List();

  UserService(this._client, this._http) {
    onLogin.listen((_) {      
      _client.jsonSubscribe('/topic/user-created', (_) {
        User user = new User.fromJsonMap(_);
        _createdUserCount++;
        _users.add(user);
        _createdEvents.add(user);
      });
      getAllUsers().then((List<User> users) {
        _users = users;
      });
    });
    _client.onDisconnected.listen((_) {
      _logoutEvents.add(_authenticatedUser);
      _authenticatedUser = null;
    });
  }

  Future<User> getAuthenticatedUser() {
    return _client.jsonSubscribeRequest('/app/usr/authenticated', (_) => new User.fromJsonMap(_));
  }

  Future<List<User>> getAllUsers() {
    return _client.jsonSubscribeRequest('/app/usr/all');
  }

  Future signin(User user) {
    return signout().then((_) => _http.post('${window.location.origin}/login', 'username=${user.username}&password=${user.password}', headers: {
        'Content-Type' : 'application/x-www-form-urlencoded'
    }).then((HttpResponse response) => _client.connectWebsocket().then((_) => getAuthenticatedUser().then((User u) {
      _authenticatedUser = u;
      _loginEvents.add(u);
    }))));
  }

  Future<User> signup(User user) {
    return signout().then((_) => _client.connectWebsocket()).then((_) => _client.jsonMessageRequest("/app/usr/signup", user, "/user/queue/user-created", (_) => new User.fromJsonMap(_))).then((User u) => signout()).catchError((_) => signout());
  }

  Future signout() {
    return _http.post('${window.location.origin}/logout', '').then((HttpResponse response) {
      _authenticatedUser = null;
    }).then((_) {
      _client.disconnect();
    });
  }

}