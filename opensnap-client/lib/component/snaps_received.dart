part of opensnap;

@Injectable()
@Component(selector: 'snaps-received', templateUrl: 'packages/opensnap/component/snaps_received.html', useShadowDom: false, publishAs: 'ctrl')
class SnapsReceivedComponent extends ShadowRootAware {

  ImageElement photo;

  SnapService _snapService;
  UserService _userService;
  Router _router;

  int progressValue = 0;
  int maxValue = 100;
  bool displayPhoto = false;
  List<Snap> get snaps => this._snapService.snapsReceived;
  bool get hasSnaps => !this._snapService.snapsReceived.isEmpty;

  SnapsReceivedComponent(this._snapService, this._userService, this._router) {
    if (!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
  }
  
  void onShadowRoot(var shadowRoot) {
    photo = shadowRoot.querySelector('#photo');
  }

  void viewSnap(Snap partialSnap) {
    // Retreive full snap with photo
    _snapService.getSnapById(partialSnap.id).then((Snap s) {
      photo.src = s.photo;
      maxValue = s.duration * 1000;
      progressValue = 10;
      displayPhoto = true;
      new Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
        if (progressValue > s.duration * 1000) {
          _snapService.deleteSnap(s);
          displayPhoto = false;
          photo.src = "";
          t.cancel();
        }
        progressValue = progressValue + 10;
      });
    });
  }
  
  String get photoClass => displayPhoto ? '' : 'hide';   
  
}