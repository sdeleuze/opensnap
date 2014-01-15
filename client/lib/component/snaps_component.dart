library snaps_component;

import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import '../service/query_service.dart';
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
  
  QueryService _queryService;
  AuthService _authService;
  Router _router;
  
  List<Snap> snaps;
  int progressValue;
  
  SnapsComponent(this._queryService, this._authService, this._router) {
    if(_authService.authenticatedUser == null) {
      _router.go('signin', new Map());
      return;
    }
  }
  
  void onShadowRoot(ShadowRoot shadowRoot) {
    photo = shadowRoot.querySelector("#photo");
    photoGroup = shadowRoot.querySelector("#photo-group");
    progress = shadowRoot.querySelector("#progress");
    
    _queryService.getSnapsFromUsername(_authService.authenticatedUser.username).then((List<Snap> s) {
      snaps = s;
    });
  }
  
  void viewSnap(Snap snap) {
    photo.src = snap.photo;
    progressValue=0;
    photoGroup.style.display = 'block';
    new Timer.periodic(new Duration(milliseconds: snap.duration * 100), (Timer t) {
      progressValue = progressValue + 10;
      if(progressValue == 110) {
        // Use the snap id to delete when implemented
        _queryService.deleteSnap(snap.id);
        snaps.remove(snap);
        photoGroup.style.display = 'none';
        t.cancel();
      }
    });
    
  }
  
}