part of opensnap;

class User {
  String username;
  String password;
  List<String> roles;

  User([this.username = "", this.password = "", List roles]) {
    this.roles = (roles == null) ? new List() : roles;
  }
    
  factory User.fromJsonMap(Map json) => new User(json['username'], json['password'], json['roles']);
  
  Map toJson() => {'username': username, 'password': password, 'roles': roles};
  
  String toJsonString() => JSON.encode(toJson());
  
  bool operator == (User other) => (other.username == username) && listEq(other.roles, roles);
}

class Snap {
  int id;
  User author;
  List<User> recipients;
  String photo;
  int duration;

  Snap(this.author, this.recipients, this.photo, this.duration, [this.id = null]);
 
  factory Snap.fromJsonMap(Map json) {
    var recipients = (json['recipients'] == null) ? null : json['recipients'].map((_) => new User.fromJsonMap(_)).toList();
    return new Snap(new User.fromJsonMap(json['author']), recipients, json['photo'], json['duration'], json['id']);
  }
    
  Map toJson() => {'id': id, 'author': author, 'recipients': recipients, 'photo': photo, 'duration': duration};
  
  String toJsonString() => JSON.encode(toJson());

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return (s.id == id && s.author == author && s.duration == duration);
  }
}