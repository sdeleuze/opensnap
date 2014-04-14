part of opensnap;

class User {
  String username;
  String password;
  List<String> roles;

  User([this.username = "", this.password = "", List roles]) {
    if (roles == null) {
      this.roles = new List();
    } else {
      this.roles = roles;
    }
  }

  factory User.fromJsonMap(Map json) {
    List<String> roles = new List<String>();
    if (json['roles'] != null) {
      for (String role in json['roles']) {
        roles.add(role);
      }
    }
    return new User(json['username'], json['password'], roles);
  }

  Map toJson() => {
      'username': username, 'password': password, 'roles': roles
  };

  String toJsonString() => JSON.encode(toJson());

  bool operator == (User other) {
    return (other.username == username) && listEq(other.roles, roles);
  }
}

class Snap {
  int id;
  User author;
  List<User> recipients;
  String photo;
  int duration;

  Snap(this.author, this.recipients, this.photo, this.duration, [this.id = null]);

  factory Snap.fromJsonMap(Map json) {
    List<User> recipients = new List<User>();
    if (json['recipients'] != null) {
      for (Map map in json['recipients']) {
        recipients.add(new User.fromJsonMap(map));
      }
    }
    return new Snap(new User.fromJsonMap(json['author']), recipients, json['photo'], json['duration'], json['id']);
  }

  Map toJson() => {
      'id': id, 'author': author, 'recipients': recipients, 'photo': photo, 'duration': duration
  };

  String toJsonString() => JSON.encode(toJson());

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return (s.id == id && s.author == author && s.duration == duration);
  }
}