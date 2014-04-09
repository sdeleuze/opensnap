part of opensnap;

class MessagingService {

  StompClient _stompClient;
  int _connexionId = 0;
  Logger _logger = new Logger('MessagingService');
  
  MessagingService();
  
  String get _id => (_connexionId++).toString();
  String get url {
    String url = window.location.origin;
    if(url.startsWith("https")) {
      url = url.replaceFirst("https", "wss");
    } else {
      url = url.replaceFirst("http", "ws");
    }
    if(url.contains("cfapps.io")) {
      url="$url:4443";
    }
    return "$url/websocket";
  }
  
  Future<StompClient> _connectIfNeeded() {
    if(_stompClient == null || _stompClient.isDisconnected) {
      return connect(url, onError: onError, onFault: onFault).then((StompClient client) {
        _stompClient = client;
        _stompClient.subscribeString(_id, "/user/queue/error", (Map<String, String> headers, String message) {
          window.alert(message);
        });
      });
    }
    return new Future<StompClient>.value(_stompClient);
  }
  
  onError(StompClient client, String message, String detail, Map<String, String> headers) {
    window.alert(message);
    _logger.fine(message, detail);
    
  }
  
  onFault(StompClient client, error, stackTrace) {
    window.alert(error);
    _logger.finer("Unknown error", error, stackTrace);
  }
  
  Future sendJsonMessage(String sendDestination, String subscribeDestination, var object, [var convert = null]) {
    return this._connectIfNeeded().then((_) {
      var completer = new Completer();
      String id = _id;
      _stompClient.subscribeJson(id, subscribeDestination, (var headers, var message) {
        if(convert == null) {
          completer.complete(message);
        } else {
          completer.complete(convert(message));
        }
        _stompClient.unsubscribe(id);
      }, matcher: ALL);
      var json = (object == null) ? {} : (object is String || object is int) ? object : object.toJson();
      _stompClient.sendJson(sendDestination, json);
      return completer.future;
    });
  }
  
  Future sendJsonSubscribe(String destination, [var convert = null]) {
    return this._connectIfNeeded().then((_) {
        var completer = new Completer();
        _stompClient.subscribeJson(_id, destination, (var headers, var message) {
          if(convert == null) {
            completer.complete(message);
          } else {
            completer.complete(convert(message));
          }
        }, matcher: ALL);
        return completer.future;
      });
    }
  
}

class UserService extends MessagingService {
  
  Future<User> getAuthenticatedUser() {
    return sendJsonSubscribe("/app/usr/authenticated", (_) => new User.fromJsonMap(_));
  }
    
  Future<List<User>> getAllUsers() {
    return sendJsonSubscribe("/app/usr/all");
  }
  
}

class SnapService extends MessagingService {
  
  Stream get onEvent => _evenController.stream;
  
  StreamController _evenController = new StreamController.broadcast();

  AuthService _authService;
  
  SnapService(this._authService) {
    _authService.onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) return this._connectIfNeeded().then((_) {
          _stompClient.subscribeJson(_id, "/user/queue/snap-received", (var headers, var message) {
            _evenController.add(new SnapEvent(SnapEvent.RECEIVED, new Snap.fromJsonMap(message)));
          }, matcher: ALL);
        });  
    });
  }
  
  Future<Snap> createSnap(Snap snap) {
    return sendJsonMessage("/app/snap/create", "/user/queue/snap-created",snap, (_) => new Snap.fromJsonMap(_));
  }
  
  Future<Snap> getSnapById(int id) {
      return sendJsonSubscribe("/app/snap/id/$id", (_) => new Snap.fromJsonMap(_));
    }
    
  Future<List<Snap>> getSnaps() {
    return sendJsonSubscribe("/app/snap/user", (_) {
      List<Snap> snaps = new List<Snap>();
      for(Map map in _) {
        snaps.add(new Snap.fromJsonMap(map));  
      }
      _evenController.add(new SnapEvent.fromSnaps(SnapEvent.RETREIVED, snaps));
      return snaps;
    });
  }
      
  void deleteSnap(Snap snap) {
    sendJsonSubscribe('/app/snap/delete-for-authenticated-user/${snap.id}');
    _evenController.add(new SnapEvent(SnapEvent.DELETED, snap));
  }
}