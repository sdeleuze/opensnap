part of opensnap;

@NgComponent(
    selector: 'notify',
    templateUrl: 'packages/opensnap/component/notify_component.html',
    cssUrl: 'packages/opensnap/component/notify_component.css',
    applyAuthorStyles: true,
    publishAs: 'ctrl'
)
class NotifyComponent {
  
  SnapService _snapService; 
  List<Notification> notifications;
  
  NotifyComponent(this._snapService) {
    notifications = new List<Notification>();
    _snapService.onEvent.listen((SnapEvent event) {
      if(event.type == SnapEvent.RECEIVED) {
        Notification notification = new Notification("New snap ${event.snap.id} published!");
        notifications.add(notification);
        new Timer(new Duration(seconds:5), () => notifications.remove(notification));
      }
    });
  }
}

class Notification {
  String message;
  Notification(this.message);
}