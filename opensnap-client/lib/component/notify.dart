part of opensnap;

@Injectable()
@Component(selector: 'notify', templateUrl: 'packages/opensnap/component/notify.html', useShadowDom: false, publishAs: 'ctrl')
class NotifyComponent {

  SnapService _snapService;
  List<Notification> notifications;

  NotifyComponent(this._snapService) {
    notifications = new List<Notification>();
    _snapService.onReceived.listen((Snap snap) {
      Notification notification = new Notification('New snap received from ${snap.author.username}!');
      notifications.add(notification);
      new Timer(new Duration(seconds:5), () => notifications.remove(notification));
    });
    _snapService.onSent.listen((Snap snap) {
      // TODO Handle multiple recipients
      Notification notification = new Notification("Snap sent to ${snap.recipients.first.username}!");
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