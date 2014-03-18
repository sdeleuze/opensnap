library photo_component;

import 'dart:html';
import 'package:angular/angular.dart';
import '../service/messaging_service.dart';
import '../service/auth_service.dart';
import '../domain.dart';

@NgComponent(
    selector: 'photo',
    templateUrl: 'packages/open_snap/component/photo_component.html',
    cssUrl: 'packages/open_snap/component/photo_component.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class PhotoComponent extends NgShadowRootAware {
  
  VideoElement video;
  CanvasElement canvas;
  ImageElement photo;
  MediaStream stream;
  DivElement photoComponent;
  ButtonElement takePhoto, send;
  SelectElement sendTo, duration;
  
  UserService _userQueryService;
  SnapService _snapQueryService;
  AuthService _authService;
  Router _router;
  
  List<User> users;
   
  PhotoComponent(this._userQueryService, this._snapQueryService, this._authService, this._router) {
    if(_authService.authenticatedUser == null) {
      _router.go('signin', new Map());
      return;
    }
    _userQueryService.getAllUsers().then((List<User> us) {
      users = us;
    });
  }
  
  void onShadowRoot(ShadowRoot shadowRoot) {
      photoComponent = shadowRoot.querySelector("#photo-component");
      video = shadowRoot.querySelector("#video");
      canvas = shadowRoot.querySelector("#canvas");
      photo = shadowRoot.querySelector("#photo");
      sendTo = shadowRoot.querySelector("#sendto");
      duration = shadowRoot.querySelector("#duration");
      takePhoto = shadowRoot.querySelector("#take-photo");
      send = shadowRoot.querySelector("#send");
      photo.hidden = true;
      window.navigator.getUserMedia(audio: false, video: true).then((s) {
        stream = s;
        video.src = Url.createObjectUrlFromStream(s);
        video.onCanPlay.listen((e) {
          video.width = video.videoWidth;
          video.height = video.videoHeight;
          canvas.width = video.videoWidth;
          canvas.height = video.videoHeight;
        });
        
    });
      
  }
  
  void takePicture() {
    canvas.context2D.drawImage(video, 0, 0);
    var data = canvas.toDataUrl('image/png');
    photo.setAttribute('src', data);
    video.hidden = true;
    photo.hidden = false;
    send.disabled = false;
  }
  
  void sendSnap() {
    stream.stop();
    String data = canvas.toDataUrl('image/png');
    Snap snap = new Snap(_authService.authenticatedUser, [new User(sendTo.value)], data, int.parse( duration.value));
    _snapQueryService.createSnap(snap).then((Snap snap) {
      _router.go('snaps', new Map());
    });
  }
  
}