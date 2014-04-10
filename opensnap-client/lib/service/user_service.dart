part of opensnap;

class UserService {

  StompClientService _client;

  UserService(this._client);

  Future<User> signup(User user) {
    return _client.disconnect().then((_) => _client.sendJsonMessage("/app/usr/signup", user, "/user/queue/user-created", (_) => new User.fromJsonMap(_)));
  }

  Future<User> getAuthenticatedUser() {
    return _client.sendJsonSubscribe("/app/usr/authenticated", (_) => new User.fromJsonMap(_));
  }

  Future<List<User>> getAllUsers() {
    return _client.sendJsonSubscribe("/app/usr/all");
  }

}