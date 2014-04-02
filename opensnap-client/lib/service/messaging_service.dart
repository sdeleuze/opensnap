part of opensnap;

class MessagingService {

  StompClient _stompClient;
  String url;
  int _connexionId = 0;
  
  MessagingService(this.url);
  
  String _id() => (_connexionId++).toString();
  
  Future<StompClient> _connectIfNeeded() {
    if(_stompClient == null || _stompClient.isDisconnected) {
      return connect(url).then((StompClient client) {
        _stompClient = client;
        _stompClient.subscribeString(_id(), "/user/queue/error", (Map<String, String> headers, String message) {
          error(message);
        });
      });
    }
    return new Future<StompClient>.value(_stompClient);
  }
  
  Future sendJsonMessage(String sendDestination, String subscribeDestination, var object, [var convert = null]) {
    return this._connectIfNeeded().then((_) {
      var completer = new Completer();
      String id = _id();
      _stompClient.subscribeJson(_id(), subscribeDestination, (Map<String, String> headers, var message) {
        if(convert == null) {
          completer.complete(message);
        } else {
          completer.complete(convert(message));
        }
        _stompClient.unsubscribe(id);
      });
      var json = (object == null) ? {} : (object is String || object is int) ? object : object.toJson();
      _stompClient.sendJson(sendDestination, json);
      return completer.future;
    });
  }
  
  Future sendJsonSubscribe(String destination, [var convert = null]) {
    return this._connectIfNeeded().then((_) {
        var completer = new Completer();
        _stompClient.subscribeJson(_id(), destination, (Map<String, String> headers, var message) {
          if(convert == null) {
            completer.complete(message);
          } else {
            completer.complete(convert(message));
          }
        });
        return completer.future;
      });
    }
}

class UserService extends MessagingService {
  
  UserService() : super("ws://$SERVER_HOST/websocket");
    
  Future<List<User>> getAllUsers() {
    return sendJsonSubscribe("/app/usr");
  }
  
}

class SnapService extends MessagingService {
  
  Stream get onEvent => _evenController.stream;
  
  StreamController _evenController = new StreamController.broadcast();

  AuthService _authService;
  
  SnapService(this._authService) : super("ws://$SERVER_HOST/websocket") {
    _authService.onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) return this._connectIfNeeded().then((_) {
          _stompClient.subscribeString(_id(), "/user/queue/snap-received", (Map<String, String> headers, String snapId) {
            _evenController.add(new SnapEvent(SnapEvent.RECEIVED, int.parse(snapId)));
          });
        });  
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return sendJsonMessage("/app/snap/create", "/user/queue/snap-created",snap, (_) => new Snap.fromJsonMap(_));
  }
  
  Future<Snap> getSnapById(int id) {
      return sendJsonSubscribe("/app/snap/id/$id", (_) => new Snap.fromJsonMap(_));
    }
    
  Future<List<Snap>> getSnapsFromUsername(String username) {
    return sendJsonSubscribe("/app/snap/username/$username", (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      _evenController.add(new SnapEvent(SnapEvent.RETREIVED, snaps));
      return snaps;
    });
  }
      
  void deleteSnap(int id, String username) {
    sendJsonSubscribe('/app/snap/delete/$id/$username');
    _evenController.add(new SnapEvent(SnapEvent.DELETED, id));
  }
}