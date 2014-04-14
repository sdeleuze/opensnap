part of opensnap;

class SnapService {

  Stream get onCreated => _createdEvents.stream;
  Stream get onReceived => _receivedEvents.stream;
  Stream get onDeleted => _deletedEvents.stream;
  Stream get onSent => _sentEvents.stream;
  
  int get createdSnapCount => _createdSnapCount;
  List<Snap> get snapsSent => _snapsSent;
  List<Snap> get snapsReceived => _snapsReceived;

  StreamController _createdEvents = new StreamController.broadcast();
  StreamController _receivedEvents = new StreamController.broadcast();
  StreamController _deletedEvents = new StreamController.broadcast();
  StreamController _sentEvents = new StreamController.broadcast();
  
  StompClientService _client;
  UserService _userService;
  int _createdSnapCount = 0;
  List<Snap> _snapsReceived = new List();
  List<Snap> _snapsSent = new List();

  SnapService(this._client, this._userService) {
    _userService.onLogin.listen((_) {
      _client.jsonSubscribe("/user/queue/snap-received", (_) {
        Snap snap = new Snap.fromJsonMap(_);
        _snapsReceived.add(snap);
        _receivedEvents.add(snap);
      });
      _client.jsonSubscribe("/topic/snap-created", (_) {
        _createdSnapCount++;
        _createdEvents.add(new Snap.fromJsonMap(_));
      });
      _client.jsonSubscribe("/user/queue/snap-deleted", (_) {
        Snap snap = new Snap.fromJsonMap(_);
        _snapsSent.remove(snap);
        _deletedEvents.add(snap);
      });
      getReceivedSnaps().then((List<Snap> snaps) {
        _snapsReceived = snaps;
      });
      getSentSnaps().then((List<Snap> snaps) {
        _snapsSent = snaps;
      });
    });
  }

  Future<Snap> createSnap(Snap snap) {
    return _client.jsonMessageRequest("/app/snap/create", snap, "/user/queue/snap-created", (_) => new Snap.fromJsonMap(_)).then((Snap snap) {
      _snapsSent.add(snap);
      _sentEvents.add(snap);
    });
  }

  Future<Snap> getSnapById(int id) {
    return _client.jsonSubscribeRequest("/app/snap/id/$id", (_) => new Snap.fromJsonMap(_));
  }

  Future<List<Snap>> getReceivedSnaps() {
    return _client.jsonSubscribeRequest("/app/snap/received", (_) {
      List<Snap> snaps = new List<Snap>();
      for (Map map in _)
        snaps.add(new Snap.fromJsonMap(map));
      return snaps;
    });
  }

  Future<List<Snap>> getSentSnaps() {
    return _client.jsonSubscribeRequest("/app/snap/sent", (_) {
      List<Snap> snaps = new List<Snap>();
      for (Map map in _)
        snaps.add(new Snap.fromJsonMap(map));
      return snaps;
    });
  }

  void deleteSnap(Snap snap) {
    _client.jsonSubscribeRequest('/app/snap/delete-for-authenticated-user/${snap.id}');
    _snapsReceived.remove(snap);
  }
}