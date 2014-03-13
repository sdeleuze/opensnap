import 'package:angular/angular.dart';
import '../lib/component/signin_component.dart';
import '../lib/component/photo_component.dart';
import '../lib/component/snaps_component.dart';
import '../lib/service/query_service.dart';
import '../lib/service/auth_service.dart';
import '../lib/component/navbar_component.dart';
import '../lib/routing.dart';
import 'package:di/di.dart';
import 'package:bootjack/bootjack.dart';


class OpenSnapModule extends Module {
  OpenSnapModule() {
    type(UserQueryService);
    type(SnapQueryService);
    type(AuthService);
    type(NavbarComponent);
    type(SigninComponent);
    type(PhotoComponent);
    type(SnapsComponent);
    type(RouteInitializer, implementedBy: OpenSnapRouteInitializer);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
  }
}

main() {
  ngBootstrap(module: new OpenSnapModule());
  
  Dropdown.use();
  Button.use();
}