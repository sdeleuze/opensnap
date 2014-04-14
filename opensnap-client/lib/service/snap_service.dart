part of opensnap;

class SnapService {
  
  Stream get onEvent => _events.stream;
  int get createdSnapCount => _createdSnapCount;
  List<Snap> get snapsSent => _snapsSent;
  List<Snap> get snapsReceived => _snapsReceived;
  
  StompClientService _client;
  UserService _userService;
  StreamController _events = new StreamController.broadcast();
  int _createdSnapCount = 0;
  List<Snap> _snapsReceived = new List();
  List<Snap> _snapsSent = new List();
   
  SnapService(this._client, this._userService) {
    _userService.onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) {
        _client.jsonSubscribe("/user/queue/snap-received", (_) {
          Snap snap = new Snap.fromJsonMap(_);
          _snapsReceived.add(snap);
          _events.add(new SnapEvent(SnapEvent.RECEIVED, snap));
        });
        _client.jsonSubscribe("/topic/snap-created", (_) {
          _createdSnapCount++;
          _events.add(new SnapEvent(SnapEvent.CREATED, new Snap.fromJsonMap(_)));
        });
        _client.jsonSubscribe("/user/queue/snap-deleted", (_) {
          Snap snap = new Snap.fromJsonMap(_);
          _snapsSent.remove(snap);
          _events.add(new SnapEvent(SnapEvent.DELETED, snap));
        });
        getReceivedSnaps().then((List<Snap> snaps) {
          _snapsReceived = snaps;
        });
        getSentSnaps().then((List<Snap> snaps) {
          _snapsSent = snaps;
        });
      }
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return _client.jsonMessageRequest("/app/snap/create",snap, "/user/queue/snap-created", (_) => new Snap.fromJsonMap(_)).then((Snap snap) {
      _snapsSent.add(snap);
      _events.add(new SnapEvent(SnapEvent.SENT, snap));
    });
  }
  
  Future<Snap> getSnapById(int id) {
      return _client.jsonSubscribeRequest("/app/snap/id/$id", (_) => new Snap.fromJsonMap(_));
    }
    
  Future<List<Snap>> getReceivedSnaps() {
    return _client.jsonSubscribeRequest("/app/snap/received", (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) snaps.add(new Snap.fromJsonMap(map));  
      return snaps;
    });
  }
  
  Future<List<Snap>> getSentSnaps() {
      return _client.jsonSubscribeRequest("/app/snap/sent", (_) {
        List<Snap> snaps = new List<Snap>();
        for(Map map in _) snaps.add(new Snap.fromJsonMap(map));  
        return snaps;
      });
    }
      
  void deleteSnap(Snap snap) {
    _client.jsonSubscribeRequest('/app/snap/delete-for-authenticated-user/${snap.id}');
    _snapsReceived.remove(snap);
  }
}