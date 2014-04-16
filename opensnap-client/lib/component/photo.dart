part of opensnap;

@NgComponent(selector: 'photo', templateUrl: 'packages/opensnap/component/photo.html', cssUrl: 'packages/opensnap/component/photo.css', applyAuthorStyles: true, publishAs: 'ctrl')
class PhotoComponent extends NgShadowRootAware {

  VideoElement video;
  CanvasElement canvas;
  ImageElement photo;
  MediaStream stream;
  ButtonElement takePhoto, send;
  SelectElement sendTo, duration;
  List<User> get users => _userService.users;
  bool isUploading = false;
  bool isReady = false;
  
  UserService _userService;
  SnapService _snapService;
  Router _router;
  String _data;
  

  PhotoComponent(this._userService, this._snapService, this._router) {
    if (!_userService.isAuthenticated) {
      _router.go('signin', new Map());
      return;
    }
  }

  void onShadowRoot(ShadowRoot shadowRoot) {
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
      video.onCanPlay.listen((e) {
        canvas.width = video.videoWidth;
        canvas.height = video.videoHeight;
        isReady = true;
      });
      video.src = Url.createObjectUrlFromStream(s);
    });

  }

  void takePicture() {
    if(!isReady) {
      window.alert("Please authorize OpenSnap to use you webcam before taking a photo ...");
      return;
    }
    canvas.context2D.drawImage(video, 0, 0);
    _data = canvas.toDataUrl('image/png');
    photo.src = _data;  
    video.hidden = true;
    photo.hidden = false;
    send.disabled = false;
  }

  void sendSnap() {
    Snap snap = new Snap(_userService.authenticatedUser, [new User(sendTo.value)], _data, int.parse(duration.value));
    isUploading = true;
    _snapService.createSnap(snap).then((Snap snap) {
      isUploading = false;
      _router.go('sent', new Map());
    });
  }

}