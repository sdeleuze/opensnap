part of opensnap;

@Injectable()
@Component(selector: 'photo', templateUrl: 'packages/opensnap/component/photo.html', useShadowDom: false, publishAs: 'ctrl')
class PhotoComponent extends ShadowRootAware {

  VideoElement video;
  CanvasElement canvas;
  ImageElement photo;
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

  void onShadowRoot(var shadowRoot) {
    video = shadowRoot.querySelector('#video');
    canvas = shadowRoot.querySelector('#canvas');
    photo = shadowRoot.querySelector('#photo');
    sendTo = shadowRoot.querySelector('#sendto');
    duration = shadowRoot.querySelector('#duration');
    takePhoto = shadowRoot.querySelector('#take-photo');
    send = shadowRoot.querySelector('#send');
    photo.hidden = true;
    window.navigator.getUserMedia(audio: false, video: true).then((s) {
      video.src = Url.createObjectUrlFromStream(s);
      if (video.readyState >= 3) {
        canPlay();
      } else {
        video.onCanPlay.listen((e) => canPlay()).onError((_) => window.alert('Unknown error while getting the webcam stream!'));
      }
    });
  }
    
  void canPlay() {
    canvas.width = video.videoWidth;
    canvas.height = video.videoHeight;
    isReady = true;
  }

  void takePicture() {
    if(!isReady) {
      window.alert('Please authorize OpenSnap to use you webcam before taking a photo ...');
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