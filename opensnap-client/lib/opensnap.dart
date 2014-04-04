library opensnap;

import 'dart:html';
import 'package:angular/angular.dart';
import 'dart:async';
import "package:stomp/stomp.dart";
import "package:stomp/websocket.dart" show connect;
import 'dart:convert';
import 'package:collection/equality.dart';
import 'package:logging_handlers/browser_logging_handlers.dart';

part "component/navbar_component.dart";
part "component/notify_component.dart";
part "component/photo_component.dart";
part "component/signin_component.dart";
part "component/snaps_component.dart";
part "component/admin_component.dart";
part "service/auth_service.dart";
part "service/messaging_service.dart";
part "domain.dart";
part "routing.dart";

//const String REST_URL = "https://127.0.0.1:8443";
//const String WEBSOCKET_URL = "wss://127.0.0.1:8443/websocket";
const String REST_URL = "http://127.0.0.1:8080";
const String WEBSOCKET_URL = "ws://127.0.0.1:8080/websocket";
Function listEq = const ListEquality().equals;


