library signin_component;

import 'dart:html';
import 'package:angular/angular.dart';
import '../domain.dart';
import '../service/messaging_service.dart';
import '../service/auth_service.dart';

@NgComponent(
    selector: 'signin',
    templateUrl: 'packages/open_snap/component/signin_component.html',
    cssUrl: 'packages/open_snap/component/signin_component.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class SigninComponent {

  User user;
  UserService _userQueryService;
  AuthService _authService;
  Router _router;
  
  SigninComponent(this._userQueryService, this._authService, this._router) {
    user = new User();
    if(this._authService.authenticatedUser != null) {
      _router.go('snaps', new Map());
    }
  }
  
  authenticate() {
    _userQueryService.authenticateUser(user).then((bool status) {
      if(status) {
        _router.go('photo', new Map());
      }
      else window.alert('Error during login');
    });
  }
}