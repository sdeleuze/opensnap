library opensnap;

import 'dart:html';
import 'dart:async';
import 'dart:convert';

import 'package:stomp/stomp.dart';
import 'package:angular/angular.dart';
import 'package:collection/equality.dart';
import 'package:logging/logging.dart';
import 'package:stomp_sockjs/stomp_sockjs.dart' as StompSockJs;

part 'component/navbar.dart';
part 'component/notify.dart';
part 'component/photo.dart';
part 'component/signin.dart';
part 'component/snaps_received.dart';
part 'component/snaps_sent.dart';
part 'component/admin.dart';
part 'service/snap_service.dart';
part 'service/user_service.dart';
part 'service/stomp_client_service.dart';
part 'domain.dart';
part 'routing.dart';

Function listEq = const ListEquality().equals;



