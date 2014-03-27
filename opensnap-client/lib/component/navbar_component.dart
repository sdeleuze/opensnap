part of opensnap;

@NgComponent(
    selector: 'navbar',
    templateUrl: 'packages/opensnap/component/navbar_component.html',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class NavbarComponent {
  
  User signedInUser;
  num snapsCount;
  AuthService _authService;
  SnapService _snapService;
  Router _router;

  NavbarComponent(this._authService, this._snapService, this._router) {
    snapsCount = 0;
    _authService.onEvent.listen((UserEvent event) {
      if(event.type == UserEvent.LOGIN) {
        signedInUser=event.user;
        _snapService.getSnapsFromUsername(signedInUser.username);
      }
    });
    _snapService.onEvent.listen((SnapEvent event) {
      switch(event.type) {
        case SnapEvent.RETREIVED:
          List<Snap> snaps = event.value;
          snapsCount = snaps.length;
          return;
        case SnapEvent.RECEIVED:
          snapsCount++;
          return;
        case SnapEvent.DELETED:
          snapsCount--;
          return;
      }
    });
  }
  
  void signout() {
    _authService.signout().then((bool status) {
      if(status) {
            signedInUser = null;
            _router.go('signin', new Map());
      }
      else window.alert('Error during logout');
    });
    
  }
  
  String photoClass() {
    if(window.location.hash == '#/photo') return 'active'; else return '';
  }
  
  String snapsClass() {
    if(window.location.hash == '#/snaps') return 'active'; else return '';
  }

}
