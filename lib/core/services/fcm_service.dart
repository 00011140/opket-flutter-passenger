import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:opket/firebase_options.dart';
import 'package:opket/core/services/app_config_service.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<String?> getFcmToken() async {
    final token = await _messaging.getToken();
    return token;
  }

  /// Initialize FCM
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final token = await _messaging.getToken();
      if (token != null) registerToken(token);

      // Listen for token refreshes
      FirebaseMessaging.instance.onTokenRefresh.listen(registerToken);
    } catch (e) {
      rethrow;
    }
  }

  static void registerToken(String token) {
    AppConfigService().registerFcm(token);
  }
}

class FcmEvents {
  static final _controller = StreamController<RemoteMessage>.broadcast();

  static Stream<RemoteMessage> get stream => _controller.stream;

  static void emit(RemoteMessage message) {
    _controller.add(message);
  }
}
