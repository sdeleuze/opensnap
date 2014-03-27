part of opensnap;

class User {
  String username;
  String password;
  
  User([this.username = "", this.password = ""]);
  
  factory User.fromJsonMap(Map json) => new User(json['username'], json['password']);
  Map toJson() => {'username': username, 'password': password};
  String toJsonString() => JSON.encode(toJson());
  
  bool operator ==(User other) {
    return (other.username == username);
  }
}

class UserEvent {
  static const String LOGIN = "retreived";
  static const String LOGOUT = "received";
  
  String type;
  User user;
  
  UserEvent(this.type, this.user);
}

class Snap {
  int id;
  User author;
  List<User> recipients;
  String photo;
  int duration;
  Function listEq = const ListEquality().equals;
  
  Snap(this.author, this.recipients, this.photo, this.duration, [this.id = null]);
  
  factory Snap.fromJsonMap(Map json) {
    List<User> recipients = new List<User>();
    for(Map map in json['recipients']) {
      recipients.add(new User.fromJsonMap(map));  
    }
    return new Snap(new User.fromJsonMap(json['author']), recipients, json['photo'], json['duration'], json['id']); 
  }
  Map toJson() => {'id': id, 'author': author, 'recipients': recipients, 'photo': photo, 'duration': duration};
  String toJsonString() => JSON.encode(toJson());
  
  bool operator==(other) {
      if (other is! Snap) return false;
      Snap s = other;
      
      return (s.id == id && s.author == author && listEq(s.recipients, recipients)  && s.duration == duration);
    }
}

class SnapEvent {
  static const String RETREIVED = "retreived";
  static const String RECEIVED = "received";
  static const String DELETED = "deleted";
  
  String type;
  var value;
  
  SnapEvent(this.type, this.value);
}