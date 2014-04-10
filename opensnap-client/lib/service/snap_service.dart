part of opensnap;

class SnapService {
  
  StreamController _evenController = new StreamController.broadcast();
  AuthService _authService;
  
  Stream get onEvent => _evenController.stream;
   
  SnapService(this._authService) {
    
  }
  
  Future<Snap> createSnap(Snap snap) {
    return new Future.value(new Snap(new User("toto", "toto"), new List(), "", 1));
  }
  
  Future<Snap> getSnapById(int id) {
    return new Future.value(new Snap(new User("toto", "toto"), new List(), "", 1));
    }
    
  Future<List<Snap>> getSnaps() {
    List snaps = new List();
    snaps.add(new Snap(new User("toto", "toto"), new List(), "", 1));
    return new Future.value(snaps);
  }
      
  void deleteSnap(Snap snap) {
   
  }
}