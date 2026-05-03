import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:opket/core/services/app_config_service.dart';
import 'package:opket/firebase_options.dart';

abstract class FirebaseInitializer {
  Future<void> init();
}

class FirebaseInitializerImpl implements FirebaseInitializer {
  final AppConfigService configService;

  FirebaseInitializerImpl({required this.configService});

  @override
  Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;

      final token = await messaging.getToken();
      if (token != null) {
        configService.registerFcm(token);
      }

      messaging.onTokenRefresh.listen(configService.registerFcm);
    } catch (e) {
      rethrow;
    }
  }
}
