part of opensnap;

@Injectable()
class StompClientService {

  Stream get onConnected => _connectedEvents.stream;
  Stream get onDisconnected => _disconnectedEvents.stream;

  String get url {
    String url = window.location.origin;
    if (url.startsWith('https')) {
      url = url.replaceFirst('https', 'wss');
    } else {
      url = url.replaceFirst('http', 'ws');
    }
    if (url.contains('cfapps.io')) {
      url = "$url:4443";
    }
    return '$url/websocket';
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
      return connect(url, onConnect: onConnect, onDisconnect: onDisconnect, onError: onError, onFault: onFault);
    }
    return new Future<StompClient>.value(_stompClient);
  }

  onConnect(StompClient client, Map<String, String> headers) {
    _stompClient = client;
    _stompClient.subscribeString(_id, '/user/queue/error', (Map<String, String> headers, String message) {
      window.alert(message);
    });
    _connectedEvents.add(this._stompClient);
  }

  onDisconnect(StompClient client) {
    _logger.info('Websocket connection has been closed.');
    _disconnectedEvents.add(this._stompClient);
    _router.go('signin', new Map());
  }

  onError(StompClient client, String message, String detail, Map<String, String> headers) {
    window.alert('Error: $message');
    _logger.fine(message, detail);

  }

  onFault(StompClient client, error, stackTrace) {
    window.alert('Unknown error: $error');
    _logger.finer('Unknown error', error, stackTrace);
  }

  Future jsonMessageRequest(String sendDestination, var object, String subscribeDestination, [var convert = null]) {
    var c = new Completer();
    String id = _id;
    _stompClient.subscribeJson(id, subscribeDestination, (var headers, var message) {
      _stompClient.unsubscribe(id);
      convert == null ? c.complete(message) : c.complete(convert(message));
    }, matcher: ALL);
    var json = (object == null) ? {
    } : (object is String || object is int) ? object : object.toJson();
    _stompClient.sendJson(sendDestination, json);
    return c.future;
  }

  Future jsonSubscribeRequest(String destination, [var convert = null]) {
    var c = new Completer();
    _stompClient.subscribeJson(_id, destination, (var headers, var message) {
      convert == null ? c.complete(message) : c.complete(convert(message));
    }, matcher: ALL);
    return c.future;
  }

  String jsonSubscribe(String destination, void onMessage(var message)) {
    String id = _id;
    _stompClient.subscribeJson(_id, destination, (var headers, var message) => onMessage(message), matcher: ALL);
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