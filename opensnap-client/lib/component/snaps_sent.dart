part of opensnap;

@Injectable()
@Component(selector: 'snaps-sent', templateUrl: 'packages/opensnap/component/snaps_sent.html', useShadowDom: false)
class SnapsSentComponent {

  SnapService _snapService;
  UserService _userService;
  Router _router;

  bool get hasSnaps => !this._snapService.snapsSent.isEmpty;

  List<Snap> get snaps => this._snapService.snapsSent;

  SnapsSentComponent(this._snapService, this._userService, this._router) {
    if (!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
  }
}