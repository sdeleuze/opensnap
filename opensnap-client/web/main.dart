import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:angular_ui/angular_ui.dart';
import 'package:logging/logging.dart';
import 'package:opensnap/opensnap.dart';
import 'dart:html';

@MirrorsUsed(targets: const['opensnap'], override: '*')
import 'dart:mirrors';

class OpenSnapModule extends Module {
  OpenSnapModule() {
    install(new AngularUIModule());
    type(StompClientService);
    type(UserService);
    type(SnapService);
    type(NavbarComponent);
    type(SigninComponent);
    type(PhotoComponent);
    type(SnapsReceivedComponent);
    type(SnapsSentComponent);
    type(NotifyComponent);
    type(AdminComponent);
    value(RouteInitializerFn, opensnapRouteInitializer);
  }
}

main() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord r) {
    window.console.log('${r.loggerName}(${r.level}): ${r.message}');
  });
  
  ngBootstrap(module: new OpenSnapModule());
  
}