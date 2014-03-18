library navbar_component;

import 'dart:html';
import 'package:angular/angular.dart';
import '../domain.dart';
import '../../lib/service/auth_service.dart';
import '../../lib/service/messaging_service.dart';

@NgComponent(
    selector: 'navbar',
    templateUrl: 'packages/open_snap/component/navbar_component.html',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class NavbarComponent {
  
  User signedInUser;
  num snapsCount;
  AuthService _authService;
  SnapService _snapService;
  Router _router;

  NavbarComponent(this._authService, this._snapService, this._router) {
    snapsCount = 0;
    _authService.onSignin.listen((User user) {
      signedInUser=user;
      _snapService.getSnapsFromUsername(user.username);
    });
    _snapService.onSnapsRetreived.listen((List<Snap> snaps) {
      snapsCount = snaps.length;
    });
  }
  
  void signout() {
    _authService.signout(signedInUser);
    signedInUser = null;
    _router.go('signin', new Map());
  }
  
  String photoClass() {
    if(window.location.hash == '#/photo') return 'active'; else return '';
  }
  
  String snapsClass() {
    if(window.location.hash == '#/snaps') return 'active'; else return '';
  }

}
