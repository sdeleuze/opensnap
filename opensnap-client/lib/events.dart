part of opensnap;

class SnapEvent {
  static const String CREATED = "created";
  static const String SENT = "sent";
  static const String RECEIVED = "received";
  static const String DELETED = "deleted";

  String type;
  Snap snap;
  List<Snap> snaps;

  SnapEvent(this.type, this.snap);

  SnapEvent.fromSnaps(this.type, this.snaps);
}

class UserEvent {
  static const String LOGIN = "login";
  static const String LOGOUT = "logout";
  static const String CREATED = "created";

  String type;
  User user;

  UserEvent(this.type, this.user);
}

class StompClientEvent {
  static const String CONNECTED = "connected";
  static const String DISCONNECTED = "disconnected";

  String type;

  StompClientEvent(this.type);
}