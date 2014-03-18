import 'package:angular/angular.dart';
import '../../lib/service/messaging_service.dart';
import 'dart:async';

@NgComponent(
    selector: 'notify',
    templateUrl: 'packages/open_snap/component/notify_component.html',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class NotifyComponent {
  
  SnapService _snapService; 
  List<Notification> notifications;
  
  NotifyComponent(this._snapService) {
    notifications = new List<Notification>();
    _snapService.onSnapPublished.listen((num id) {
      Notification notification = new Notification("New snap $id published!");
      notifications.add(notification);
      new Timer(new Duration(seconds:3), () => notifications.remove(notification));
    });
  }
}

class Notification {
  String message;
  Notification(this.message);
}