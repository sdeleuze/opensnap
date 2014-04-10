import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:angular_ui/angular_ui.dart';
import 'package:logging/logging.dart';
import 'package:opensnap/opensnap.dart';
import 'dart:html';

@MirrorsUsed(targets: const['angular',
                            'angular.core',
                            'angular.core.dom',
                            'angular.filter',
                            'angular.perf',
                            'angular.directive',
                            'angular.routing',
                            'angular.core.parser',
                            NodeTreeSanitizer,
                            'angular_ui','opensnap'], override: '*')
import 'dart:mirrors';

class OpenSnapModule extends Module {
  OpenSnapModule() {
    install(new AngularUIModule());
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
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord r) {
    window.console.log('${r.loggerName}(${r.level}): ${r.message}');
  });
  
  Injector i = ngBootstrap(module: new OpenSnapModule());
  AuthService a = i.get(AuthService);
  a.authenticatedUser = new User("toto", "toto");
  a.eventController.add(new UserEvent(UserEvent.LOGIN, new User("toto", "toto")));
  
  Router router = i.get(Router);
  router.go('photo', new Map());
  
}