part of opensnap;

@NgComponent(selector: 'admin', templateUrl: 'packages/opensnap/component/admin.html', applyAuthorStyles: true, publishAs: 'ctrl')
class AdminComponent {

  UserService _userService;

  int get userCount => _userService.createdUserCount;

  SnapService _snapService;

  int get snapCount => _snapService.createdSnapCount;

  Router _router;

  AdminComponent(this._userService, this._snapService, this._router) {
    if (!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
  }
}