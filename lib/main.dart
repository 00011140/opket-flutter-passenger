import 'package:flutter/widgets.dart';
import 'package:opket/app/app.dart';
import 'package:opket/app/app_initializer.dart';

Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();

  runApp(const MyApp());
}


  // final stopwatch = Stopwatch()..start();

  // await AppInitializer.init();

  // stopwatch.stop();
  // print('AppInitializer.init() took: ${stopwatch.elapsedMilliseconds} ms');