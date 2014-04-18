part of opensnap;

@NgComponent(selector: 'admin', templateUrl: 'packages/opensnap/component/admin.html', applyAuthorStyles: true, publishAs: 'ctrl')
class AdminComponent {

  int get userCount => _userService.createdUserCount;
  int get snapCount => _snapService.createdSnapCount;
  
  UserService _userService;
  SnapService _snapService;
  Router _router;

  AdminComponent(this._userService, this._snapService, this._router) {
    if (!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
  }
}