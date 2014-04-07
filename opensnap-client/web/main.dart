import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:bootjack/bootjack.dart';
import 'package:logging/logging.dart';
import 'package:opensnap/opensnap.dart';
import 'dart:html';

@MirrorsUsed(targets: const['opensnap'], override: '*')
import 'dart:mirrors';

class OpenSnapModule extends Module {
  OpenSnapModule() {
    type(UserService);
    type(AuthService);
    type(SnapService);
    type(NavbarComponent);
    type(SigninComponent);
    type(PhotoComponent);
    type(SnapsComponent);
    type(NotifyComponent);
    type(AdminComponent);
    value(RouteInitializerFn, opensnapRouteInitializer);
  }
}

main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord r) {
    window.console.log('${r.loggerName}(${r.level}): ${r.message}');
  });
  
  ngBootstrap(module: new OpenSnapModule());
  
  Dropdown.use();
  Button.use();
  
 
}