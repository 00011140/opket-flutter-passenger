import 'package:get_it/get_it.dart';
import 'package:opket/services/auth_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  sl.registerSingleton<AuthStorage>(AuthStorage(prefs));
}
