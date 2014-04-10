part of opensnap;

class UserService {

  UserService();

  Future<User> signup(User user) {
    return new Future.value(new User("toto", "toto"));
  }

  Future<User> getAuthenticatedUser() {
    return new Future.value(new User("toto", "toto"));
  }

  Future<List<User>> getAllUsers() {
    List users = new List();
    users.add(new User("toto", "toto"));
    return new Future.value(users);
  }

}