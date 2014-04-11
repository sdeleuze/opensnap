part of opensnap;

class SnapService {
  
  Stream get onEvent => _eventController.stream;
  int get createdSnapCount => _createdSnapCount;
  List<Snap> get snapsSent => _snapsSent;
  List<Snap> get snapsReceived => _snapsReceived;
  
  StompClientService _client;
  UserService _userService;
  StreamController _eventController = new StreamController.broadcast();
  int _createdSnapCount = 0;
  List<Snap> _snapsReceived = new List();
  List<Snap> _snapsSent = new List();
   
  SnapService(this._client, this._userService) {
    _userService.onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) return _client._connectIfNeeded().then((_) {
        _client.subscribeJson("/user/queue/snap-received", (var headers, var message) {
          Snap snap = new Snap.fromJsonMap(message);
          _snapsReceived.add(snap);
          _eventController.add(new SnapEvent(SnapEvent.RECEIVED, snap));
        });
        _client.subscribeJson("/topic/snap-created", (var headers, var message) {
          _createdSnapCount++;
          _eventController.add(new SnapEvent(SnapEvent.CREATED, new Snap.fromJsonMap(message)));
        });
        _client.subscribeJson("/user/queue/snap-deleted", (var headers, var message) {
          Snap snap = new Snap.fromJsonMap(message);
          _snapsSent.remove(snap);
          _eventController.add(new SnapEvent(SnapEvent.DELETED, snap));
        });
        getReceivedSnaps().then((List<Snap> snaps) {
          _snapsReceived = snaps;
        });
        getSentSnaps().then((List<Snap> snaps) {
          _snapsSent = snaps;
        });
      });
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return _client.sendJsonMessage("/app/snap/create",snap, "/user/queue/snap-created", (_) => new Snap.fromJsonMap(_)).then((Snap snap) {
      _snapsSent.add(snap);
      _eventController.add(new SnapEvent(SnapEvent.SENT, snap));
    });
  }
  
  Future<Snap> getSnapById(int id) {
      return _client.sendJsonSubscribe("/app/snap/id/$id", (_) => new Snap.fromJsonMap(_));
    }
    
  Future<List<Snap>> getReceivedSnaps() {
    return _client.sendJsonSubscribe("/app/snap/received", (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      return snaps;
    });
  }
  
  Future<List<Snap>> getSentSnaps() {
      return _client.sendJsonSubscribe("/app/snap/sent", (_) {
        List<Snap> snaps = new List<Snap>();
        for(Map map in _) {
          snaps.add(new Snap.fromJsonMap(map));  
        }
        return snaps;
      });
    }
      
  void deleteSnap(Snap snap) {
    _client.sendJsonSubscribe('/app/snap/delete-for-authenticated-user/${snap.id}');
    _snapsReceived.remove(snap);
  }
}