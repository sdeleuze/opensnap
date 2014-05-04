part of opensnap;

class User {
  String id;
  String username;
  String password;
  List<String> roles;

  User([this.username = "", this.password = "", List roles, this.id = null]) {
    this.roles = (roles == null) ? new List() : roles;
  }
    
  factory User.fromJsonMap(Map json) {
    var id = (json['_id'] == null) ? null : json['_id']['\$oid'];
    return new User(json['username'], json['password'], json['roles'], id);
  }
  
  Map toJson() => {'_id': {'\$oid': id}, 'username': username, 'password': password, 'roles': roles};
  
  String toJsonString() => JSON.encode(toJson());
  
  bool operator == (User other) => (other.username == username) && listEq(other.roles, roles);
}

class Snap {
  String id;
  User author;
  List<User> recipients;
  String photo;
  int duration;

  Snap(this.author, this.recipients, this.photo, this.duration, [this.id = null]);
 
  factory Snap.fromJsonMap(Map json) {
    var id = (json['_id'] == null) ? null : json['_id']['\$oid'];
    var recipients = (json['recipients'] == null) ? null : json['recipients'].map((_) => new User.fromJsonMap(_)).toList();
    return new Snap(new User.fromJsonMap(json['author']), recipients, json['photo'], json['duration'], id);
  }
    
  Map toJson() => {'_id': {'\$oid': id}, 'author': author, 'recipients': recipients, 'photo': photo, 'duration': duration};
  
  String toJsonString() => JSON.encode(toJson());

  bool operator == (other) {
    if (other is! Snap) return false;
    Snap s = other;
    return (s.id == id && s.author == author && s.duration == duration);
  }
}