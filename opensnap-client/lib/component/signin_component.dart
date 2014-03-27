part of opensnap;

@NgComponent(
    selector: 'signin',
    templateUrl: 'packages/opensnap/component/signin_component.html',
    cssUrl: 'packages/opensnap/component/signin_component.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class SigninComponent {

  User user;
  AuthService _authService;
  Router _router;
  
  SigninComponent(this._authService, this._router) {
    user = new User();
    if(this._authService.authenticatedUser != null) {
      _router.go('snaps', new Map());
    }
  }
  
  authenticate() {
    _authService.signin(user).then((bool status) {
      if(status) {
        _router.go('photo', new Map());
      }
      else window.alert('Error during login');
    });
  }
}