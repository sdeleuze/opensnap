part of opensnap;

@NgComponent(
    selector: 'snaps',
    templateUrl: 'packages/opensnap/component/snaps_component.html',
    cssUrl: 'packages/opensnap/component/snaps_component.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class SnapsComponent {
  
  ImageElement photo;
  DivElement photoGroup;
  DivElement progress;
  
  SnapService _snapService;
  UserService _userService;
  Router _router;

  List<Snap> snaps = new List();
  int progressValue;
  int maxValue;
  
  bool displayPhoto = false;
  String imgData = "";
  
  bool get hasSnaps => this.snaps.isEmpty;
  bool get hasImgData => this.imgData.isEmpty;
  
  SnapsComponent(this._snapService, this._userService, this._router) {
    if(!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
    _updateSnaps();
    _snapService.onEvent.listen((SnapEvent event) {
      if(event.type == SnapEvent.RECEIVED) {
        this.snaps.add(event.snap);
      }
    });
  }
  
  void viewSnap(Snap partialSnap) {
    // Retreive full snap with photo
    _snapService.getSnapById(partialSnap.id).then((Snap s) {
      imgData = s.photo;
      maxValue = s.duration * 1000;
      progressValue=10;
      displayPhoto = true;
      new Timer.periodic(new Duration(milliseconds: 10), (Timer t) {
        if(progressValue > s.duration * 1000) {
          _snapService.deleteSnap(s);
          snaps.remove(s);
          displayPhoto = false;
          imgData = "";
          t.cancel();
        }
        progressValue = progressValue + 10;
      });
    });
  }
  
  void _updateSnaps() {
    if(_userService.authenticatedUser != null) {
      _snapService.getSnaps().then((List<Snap> s) {
        snaps = s;
      });
    }
  }
  
}