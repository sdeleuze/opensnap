library snaps_component;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import '../service/messaging_service.dart';
import '../service/auth_service.dart';
import '../domain.dart';

@NgComponent(
    selector: 'snaps',
    templateUrl: 'packages/open_snap/component/snaps_component.html',
    cssUrl: 'packages/open_snap/component/snaps_component.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class SnapsComponent extends NgShadowRootAware {
  
  ImageElement photo;
  DivElement photoGroup;
  DivElement progress;
  
  SnapService _snapService;
  AuthService _authService;
  Router _router;
  
  List<Snap> snaps;
  int progressValue;
  
  SnapsComponent(this._snapService, this._authService, this._router) {
    if(_authService.authenticatedUser == null) {
      _router.go('signin', new Map());
      return;
    }
  }
  
  void onShadowRoot(ShadowRoot shadowRoot) {
    photo = shadowRoot.querySelector("#photo");
    photoGroup = shadowRoot.querySelector("#photo-group");
    progress = shadowRoot.querySelector("#progress");
    _updateSnaps();
  }
  
  void viewSnap(Snap partialSnap) {
    // Retreive full snap with photo
    _snapService.getSnapById(partialSnap.id).then((Snap s) {
      photo.src = s.photo;
      progressValue=0;
      photoGroup.style.display = 'block';
      new Timer.periodic(new Duration(milliseconds: s.duration * 100), (Timer t) {
        progressValue = progressValue + 10;
        if(progressValue == 110) {
          _snapService.deleteSnap(s.id);
          snaps.remove(s);
          photoGroup.style.display = 'none';
          t.cancel();
        }
      });
    });
  }
  
  void _updateSnaps() {
    if(_authService.authenticatedUser != null) {
      _snapService.getSnapsFromUsername(_authService.authenticatedUser.username).then((List<Snap> s) {
        snaps = s;
      });
    }
  }
  
}