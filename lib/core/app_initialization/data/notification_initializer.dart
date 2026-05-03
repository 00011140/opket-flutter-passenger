import 'package:awesome_notifications/awesome_notifications.dart';

abstract class NotificationInitializer {
  Future<void> init();
}

class NotificationInitializerImpl implements NotificationInitializer {
  static const GENERAL_NOTIFICATIONS_KEY = "general_notifications_v8";
  static const RIDE_NOTIFICATIONS_KEY = "ride_notifications_v1";

  @override
  Future<void> init() async {
    await AwesomeNotifications().initialize(null, [
      NotificationChannel(
        channelKey: RIDE_NOTIFICATIONS_KEY,
        channelName: 'Ride notifications',
        channelDescription: 'Ride related updates',
        importance: NotificationImportance.Max,
        playSound: true,
        soundSource: 'resource://raw/notification_sound',
      ),
      NotificationChannel(
        channelKey: GENERAL_NOTIFICATIONS_KEY,
        channelName: 'General notifications',
        channelDescription: 'General updates',
        importance: NotificationImportance.Max,
        playSound: true,
        soundSource: 'resource://raw/notification_sound',
      ),
    ]);
  }
}
