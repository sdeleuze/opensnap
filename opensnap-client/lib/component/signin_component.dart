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
  String passwordToVerify;
  AuthService _authService;
  UserService _userService;
  Router _router;
  bool isNewUser = false;
  
  SigninComponent(this._authService, this._userService, this._router) {
    user = new User();
    if(this._authService.authenticatedUser != null) {
      _router.go('snaps', new Map());
    }
  }

  submit() {
    if (isNewUser) _signup();
    else _authenticate();
  }

  _signup() {
    if(user.password != passwordToVerify) {
      window.alert("Password mismatch");
      return;
    }
    this._userService.signup(user).then((_) {
      isNewUser = false;
      _authenticate();
    }).catchError((_) => window.alert('Error during signup!'));
  }

  _authenticate() {
    _authService.signin(user)
        .then((bool status) => _router.go('photo', new Map())
    ).catchError((_) => window.alert('Error during login'));
  }

  signupMode(MouseEvent e) {
    isNewUser = true;
    e.preventDefault();
  }


}