library navbar_component;

import 'dart:html';
import 'package:angular/angular.dart';
import '../domain.dart';
import '../../lib/service/auth_service.dart';

@NgComponent(
    selector: 'navbar',
    templateUrl: 'packages/open_snap/component/navbar_component.html',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class NavbarComponent {
  
  User signedInUser;
  AuthService _eventService;
  Router _router;

  NavbarComponent(this._eventService, this._router) {
    _eventService.onSignin.listen((User user) {
      signedInUser=user;
    });
  }
  
  void signout() {
    _eventService.signout(signedInUser);
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
