import 'package:angular/angular.dart';
import 'package:di/di.dart';
import 'package:bootjack/bootjack.dart';
import 'package:opensnap/opensnap.dart';

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