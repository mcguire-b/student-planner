import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Create an instance of the notifications plugin
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Call this once at app startup to initialize notification settings
  static Future<void> initialize() async {
    // Set up Android-specific initialization (like app icon)
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Combine platform-specific settings into one initialization settings object
    const InitializationSettings settings = InitializationSettings(
      android: androidInit,
    );

    // Initialize the plugin with the settings
    await _notificationsPlugin.initialize(settings);
  }

  // Show a simple notification instantly
  static Future<void> showNotification(String title, String body) async {
    // Define how the notification should look and behave on Android
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',     // A unique channel ID
      'channel_name',   // A user-visible name for the channel
      importance: Importance.max, // Make it high priority
      priority: Priority.high,    // Ensure it shows up immediately
    );

    // Combine platform-specific details
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    // Show the notification with an ID of 0
    await _notificationsPlugin.show(0, title, body, details);
  }
}