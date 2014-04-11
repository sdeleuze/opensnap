part of opensnap;

class StompClientService {
  StompClient _stompClient;
  int _connexionId = 0;
  Stream get onEvent => _eventController.stream;
  StreamController _eventController = new StreamController.broadcast();
  Logger _logger = new Logger('StompClientService');
  Router _router;
  
  StompClientService(this._router);
  
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
        return connect(url, onConnect: onConnect, onDisconnect: onDisconnect, onError: onError, onFault: onFault);
      }
      return new Future<StompClient>.value(_stompClient);
    }
  
    onConnect(StompClient client, Map<String, String> headers) {
      _stompClient = client;
      _stompClient.subscribeString(_id, "/user/queue/error", (Map<String, String> headers, String message) {
        window.alert(message);
      });
      _eventController.add(new StompClientEvent(StompClientEvent.CONNECTED));
    }
    
    onDisconnect(StompClient client) {
      _logger.info("Websocket connection has been closed.");
      _eventController.add(new StompClientEvent(StompClientEvent.DISCONNECTED));
      _router.go('signin', new Map());
    }
    
    onError(StompClient client, String message, String detail, Map<String, String> headers) {
      window.alert("Error: $message");
      _logger.fine(message, detail);
      
    }
    
    onFault(StompClient client, error, stackTrace) {
      window.alert("Unknown error: $error");
      _logger.finer("Unknown error", error, stackTrace);
    }
    
    Future sendJsonMessage(String sendDestination, var object, String subscribeDestination, [var convert = null]) {
        return _connectIfNeeded().then((_) {
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
    
    String subscribeJson(String destination, void onMessage(Map<String, String> headers, message)) {
      String id = _id;
      _stompClient.subscribeJson(id, destination, onMessage, matcher: ALL);
      return id;
    }
    
    unsubscribe(String id) {
      _stompClient.unsubscribe(id);
    }
    
    Future disconnect() {
      if(_stompClient == null || _stompClient.isDisconnected) {
        return new Future.value();
      } else {
        Future f = _stompClient.disconnect();
        return f;
      }
    }
}

class StompClientEvent {
  static const String CONNECTED = "connected";
  static const String DISCONNECTED = "disconnected";
  
  String type;
  
  StompClientEvent(this.type);

}