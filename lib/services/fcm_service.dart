import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:opket/firebase_options.dart';
import 'package:opket/services/app_config_service.dart';
import 'package:opket/services/notification_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message here
  debugPrint("BG message: ${message.messageId} data=${message.data}");
  // NotificationService.show(
  //   title: "Cobalt",
  //   body: "Haydovchi yo'lda",
  //   wakeUpScreen: true,
  //   fullScreenIntent: true,
  // );
}

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

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      //   FcmEvents.emit(message);
      // });
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
