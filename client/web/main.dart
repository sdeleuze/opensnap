import 'package:angular/angular.dart';
import '../lib/component/signin_component.dart';
import '../lib/component/photo_component.dart';
import '../lib/component/snaps_component.dart';
import '../lib/component/navbar_component.dart';
import '../lib/component/notify_component.dart';
import '../lib/service/messaging_service.dart';
import '../lib/service/auth_service.dart';
import '../lib/routing.dart';
import 'package:di/di.dart';
import 'package:bootjack/bootjack.dart';

class OpenSnapModule extends Module {
  OpenSnapModule() {
    type(UserService);
    type(SnapService);
    type(AuthService);
    type(NavbarComponent);
    type(SigninComponent);
    type(PhotoComponent);
    type(SnapsComponent);
    type(NotifyComponent);
    type(RouteInitializerFn, implementedBy: Routes);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

main() {
  Injector injector = ngBootstrap(module: new OpenSnapModule());
  
  Dropdown.use();
  Button.use();
  
}