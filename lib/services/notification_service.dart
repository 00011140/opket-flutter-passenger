import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  static const GENERAL_NOTIFICATIONS_KEY = "general_notifications_v8";
  static const RIDE_NOTIFICATIONS_KEY = "ride_notifications_v1";

  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: RIDE_NOTIFICATIONS_KEY,
        channelName: 'Ride notifications',
        channelDescription:
            'This notification informs user about ride releated, important information',
        importance: NotificationImportance.Max,
        playSound: true,
        soundSource: 'resource://raw/notification_sound',
      ),
      NotificationChannel(
        channelKey: GENERAL_NOTIFICATIONS_KEY,
        channelName: 'For general notifications',
        channelDescription: 'This channel is for general notifications',
        importance: NotificationImportance.Max,
        playSound: true,
        soundSource: 'resource://raw/notification_sound',
      ),
    ]);
  }

  // ==========================================================
  // REGULAR SHOW NOTIFICATION (WHAT YOU ASKED FOR)
  // ==========================================================
  static Future<void> show({
    required String? title,
    required String body,
    bool wakeUpScreen = false,
    bool fullScreenIntent = false,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: GENERAL_NOTIFICATIONS_KEY,
        title: title,
        body: body,
        notificationLayout: NotificationLayout.Messaging,
        fullScreenIntent: fullScreenIntent,
        wakeUpScreen: wakeUpScreen,
      ),
    );
  }
}
