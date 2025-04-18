import 'dart:html';

class NotificationService { // ✅ Not WebNotificationService!
  static void showNotification(String title, String body) {
    if (Notification.supported) {
      Notification.requestPermission().then((permission) {
        if (permission == 'granted') {
          Notification(title, body: body);
        }
      });
    }
  }
}