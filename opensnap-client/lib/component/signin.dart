part of opensnap;

@NgComponent(
    selector: 'signin',
    templateUrl: 'packages/opensnap/component/signin.html',
    cssUrl: 'packages/opensnap/component/signin.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class SigninComponent {

  User user;
  String passwordToVerify;
  UserService _userService;
  Router _router;
  bool isNewUser = false;
  
  SigninComponent(this._userService, this._router) {
    user = new User();
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
      return _authenticate();
    }).catchError((_) => window.alert('Error during signup!'));
  }

  Future _authenticate() {
    return _userService.signin(user)
        .then((bool status) => _router.go('photo', new Map())
    ).catchError((_) => window.alert('Error during login'));
  }

  signupMode(MouseEvent e) {
    isNewUser = true;
    e.preventDefault();
  }


}