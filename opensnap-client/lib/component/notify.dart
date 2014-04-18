part of opensnap;

@NgComponent(selector: 'notify', templateUrl: 'packages/opensnap/component/notify.html', cssUrl: 'packages/opensnap/component/notify.css', applyAuthorStyles: true, publishAs: 'ctrl')
class NotifyComponent {

  SnapService _snapService;
  List<Notification> notifications;

  NotifyComponent(this._snapService) {
    notifications = new List<Notification>();
    _snapService.onReceived.listen((Snap snap) {
      Notification notification = new Notification('New snap ${snap.id} received!');
      notifications.add(notification);
      new Timer(new Duration(seconds:5), () => notifications.remove(notification));
    });
    _snapService.onSent.listen((Snap snap) {
      // TODO Handle multiple recipients
      Notification notification = new Notification("Snap ${snap.id} sent to ${snap.recipients.first.username}!");
      notifications.add(notification);
      new Timer(new Duration(seconds:5), () => notifications.remove(notification));
    });
  }
  
  void closeAlert(index) {
    notifications.removeAt(index);
  }
}

class Notification {
  String message;
  String type;

  Notification(this.message, [this.type = 'success']);
}