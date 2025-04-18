import 'package:flutter/foundation.dart' show kIsWeb;
import 'notification_service.dart'
    if (dart.library.html) 'web_notification_service.dart';

class CrossPlatformNotifier {
  static void showNotification(String title, String body) {
    if (kIsWeb) {
      NotificationService.showNotification(title, body);
    } 
  }
}