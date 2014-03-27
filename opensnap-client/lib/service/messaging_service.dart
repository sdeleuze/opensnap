part of opensnap;

class MessagingService {

  StompClient _stompClient;
  String url;
  int _connexionId = 0;
  
  MessagingService(this.url);
  
  Future<StompClient> _connectIfNeeded() {
    if(_stompClient == null || _stompClient.isDisconnected) {
      return connect(url).then((StompClient client) {
        _stompClient = client;
      });
    }
    return new Future<StompClient>.value(_stompClient);
  }
  
  Future sendJson(String destination, [var object = null, var convert = null]) {
    return this._connectIfNeeded().then((_) {
      var completer = new Completer();
      String id = (_connexionId++).toString();
      _stompClient.subscribeJson(id, "/topic${destination}", (Map<String, String> headers, var message) {
        if(convert == null) {
          completer.complete(message);
        } else {
          completer.complete(convert(message));
        }
        _stompClient.unsubscribe(id);
      });
      var json = (object == null) ? {} : (object is String || object is int) ? object : object.toJson();
      _stompClient.sendJson("/app${destination}", json);
      return completer.future;
    });
  }
  
  Future sendString(String destination, [String value = ""]) {
    return this._connectIfNeeded().then((_) {
      var completer = new Completer();
      String id = (_connexionId++).toString();
      _stompClient.subscribeJson(id, "/topic${destination}", (Map<String, String> headers, var message) {
        completer.complete(message);
        _stompClient.unsubscribe(id);
      });
      _stompClient.sendString("/app${destination}", value);
      return completer.future;
    });
  }
}

class UserService extends MessagingService {
  
  UserService() : super("ws://$SERVER_HOST/websocket");
    
  Future<List<User>> getAllUsers() {
    return sendJson("/usr");
  }
  
}

class SnapService extends MessagingService {
  
  Stream get onEvent => _evenController.stream;
  
  StreamController _evenController = new StreamController.broadcast();

  AuthService _authService;
  
  SnapService(this._authService) : super("ws://$SERVER_HOST/websocket") {
    _authService.onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) return this._connectIfNeeded().then((_) {
          String id = (_connexionId++).toString();
          _stompClient.subscribeString(id, "/user/queue/snap/published", (Map<String, String> headers, String id) {
            _evenController.add(new SnapEvent(SnapEvent.RECEIVED, int.parse(id)));
          });
        });  
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return sendJson("/snap/create", snap, (_) => new Snap.fromJsonMap(_));
  }
  
  Future<Snap> getSnapById(int id) {
      return sendJson("/snap/$id", null, (_) => new Snap.fromJsonMap(_));
    }
    
  Future<List<Snap>> getSnapsFromUsername(String username) {
    return sendJson("/snap", username, (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      _evenController.add(new SnapEvent(SnapEvent.RETREIVED, snaps));
      return snaps;
    });
  }
      
  void deleteSnap(int id, String username) {
    sendJson('/snap/delete/$id/$username');
    _evenController.add(new SnapEvent(SnapEvent.DELETED, id));
  }
}