import 'package:opket/core/app_initialization/domain/initialize_app.dart';
import 'package:opket/core/di/sl.dart';

class AppInitializer {
  static Future<void> init() async {
    try {
      await setupDependencies();

      final initializeApp = sl<InitializeApp>();
      await initializeApp();
    } catch (e) {
      print(e.toString());
    }
  }
}
