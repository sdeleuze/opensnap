part of opensnap;

@Injectable()
@Component(selector: 'navbar', templateUrl: 'packages/opensnap/component/navbar.html', useShadowDom: false, publishAs: 'ctrl')
class NavbarComponent {

  User signedInUser;
  num snapsCount;
  UserService _userService;
  SnapService _snapService;

  List<Snap> get snapsReceived => _snapService.snapsReceived;

  List<Snap> get snapsSent => _snapService.snapsSent;

  Router _router;

  NavbarComponent(this._userService, this._snapService, this._router) {
    snapsCount = 0;
    _userService.onLogin.listen((User u) => signedInUser = u);
    _userService.onLogout.listen((_) => signedInUser = null);
  }

  void goToReceived(MouseEvent e) {
    _router.go('received', new Map());
    e.preventDefault();
  }

  void goToSent(MouseEvent e) {
    _router.go('sent', new Map());
    e.preventDefault();
  }

  void goToPhoto(MouseEvent e) {
    _router.go('photo', new Map());
    e.preventDefault();
  }

  void goToAdmin(MouseEvent e) {
    _router.go('admin', new Map());
    e.preventDefault();
  }

  void signout() {
    _userService.signout().then((_) {
      signedInUser = null;
      _router.go('signin', new Map());
    }).catchError((_) => window.alert('Error during logout'));

  }

  String get photoClass {
    if (window.location.pathname.endsWith('/photo')) return 'active'; else return '';
  }

  String get receivedClass {
    if (window.location.pathname.endsWith('/received')) return 'active'; else return '';
  }

  String get sentClass {
    if (window.location.pathname.endsWith('/sent')) return 'active'; else return '';
  }

  String get adminClass {
    if (window.location.pathname.endsWith('/admin')) return 'active'; else return '';
  }

}
