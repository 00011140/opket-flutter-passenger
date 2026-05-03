import 'package:opket/core/app_initialization/data/firebase_initializer.dart';
import 'package:opket/core/app_initialization/data/notification_initializer.dart';

class InitializeApp {
  final FirebaseInitializer firebaseInitializer;
  final NotificationInitializer notificationInitializer;

  InitializeApp({
    required this.firebaseInitializer,
    required this.notificationInitializer,
  });

  Future<void> call() async {
    try {
      print("%%%%%%%%%");
      // await firebaseInitializer.init();
      await notificationInitializer.init();
    } catch (e) {
      rethrow;
    }
  }
}
