import 'package:flutter/material.dart';
import 'package:opket/app/app_providers.dart';
import 'package:opket/core/theme/theme.dart';
import 'package:opket/app/router/app_router.dart';
import 'package:opket/feat/dashboard/dashboard_new.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        // showPerformanceOverlay: true,
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: appLightTheme,
        home: const DashboardNew(),
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
