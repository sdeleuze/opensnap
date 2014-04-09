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
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

main() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((LogRecord r) {
    window.console.log('${r.loggerName}(${r.level}): ${r.message}');
  });
  
  ngBootstrap(module: new OpenSnapModule());
  
}