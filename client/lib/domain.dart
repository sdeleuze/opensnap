import 'dart:convert';

class User {
  String username;
  String password;
  
  User(this.username, [this.password = ""]);
  
  factory User.fromJsonMap(Map json) => new User(json['username'], json['password']);
  Map toJson() => {'username': username, 'password': password};
  String toJsonString() => JSON.encode(toJson());
  
  bool operator ==(User other) {
    return (other.username == username) && (other.password == password);
  }
}

class Snap {
  int id;
  User author;
  User recipient;
  String photo;
  int duration;
  
  Snap(this.author, this.recipient, this.photo, this.duration, [this.id = null]);
  
  factory Snap.fromJsonMap(Map json) => new Snap(new User.fromJsonMap(json['author']), new User.fromJsonMap(json['recipient']), json['photo'], json['duration'], json['id']);
  Map toJson() => {'id': id, 'author': author, 'recipient': recipient, 'photo': photo, 'duration': duration};
  String toJsonString() => JSON.encode(toJson());
}