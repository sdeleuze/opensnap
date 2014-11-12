part of opensnap;

@Injectable()
@Component(selector: 'photo', templateUrl: 'packages/opensnap/component/photo.html', useShadowDom: false)
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
    video = querySelector('#video');
    canvas = querySelector('#canvas');
    photo = querySelector('#photo');
    sendTo = querySelector('#sendto');
    duration = querySelector('#duration');
    takePhoto = querySelector('#take-photo');
    send = querySelector('#send');
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
      window.alert('');
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