part of opensnap;

@Injectable()
class StompClientService {

  Stream get onConnected => _connectedEvents.stream;
  Stream get onDisconnected => _disconnectedEvents.stream;

  String get url {
    String url = window.location.origin;
    if (url.contains('cfapps.io')) {
      url = "$url:4443";
    }
    return '$url/sockjs';
  }

  StreamController _connectedEvents = new StreamController.broadcast();
  StreamController _disconnectedEvents = new StreamController.broadcast();
  
  StompClient _stompClient;
  int _connexionId = 0;
  Logger _logger = new Logger('StompClientService');
  Router _router;

  String get _id => (_connexionId++).toString();

  StompClientService(this._router);

  Future<StompClient> connectWebsocket() {
    if (_stompClient == null || _stompClient.isDisconnected) {
      return StompSockJs.connect(url).then(onConnect).catchError(onError);
    }
    return new Future<StompClient>.value(_stompClient);
  }

  onConnect(StompClient client) {
    _stompClient = client;
    _stompClient.subscribeString(_id, '/user/queue/error', (Map<String, String> headers, String message) {
      window.alert(message);
    });
    _connectedEvents.add(this._stompClient);
  }

  void onError(error) {
    window.alert('Error: $error');
    _logger.fine(error);
  }

  Future jsonMessageRequest(String sendDestination, var object, String subscribeDestination, [var convert = null]) {
    var c = new Completer();
    String id = _id;
    _stompClient.subscribeJson(id, subscribeDestination, (var headers, var message) {
      _stompClient.unsubscribe(id);
      convert == null ? c.complete(message) : c.complete(convert(message));
    });
    var json = (object == null) ? {
    } : (object is String || object is int) ? object : object.toJson();
    _stompClient.sendJson(sendDestination, json);
    return c.future;
  }

  Future jsonSubscribeRequest(String destination, [var convert = null]) {
    var c = new Completer();
    _stompClient.subscribeJson(_id, destination, (var headers, var message) {
      convert == null ? c.complete(message) : c.complete(convert(message));
    });
    return c.future;
  }

  String jsonSubscribe(String destination, void onMessage(var message)) {
    String id = _id;
    _stompClient.subscribeJson(_id, destination, (var headers, var message) => onMessage(message));
    return id;
  }

  unsubscribe(String id) {
    _stompClient.unsubscribe(id);
  }

  Future disconnect() {
    if (_stompClient == null || _stompClient.isDisconnected) {
      return new Future.value();
    } else {
      Future f = _stompClient.disconnect();
      return f;
    }
  }
}