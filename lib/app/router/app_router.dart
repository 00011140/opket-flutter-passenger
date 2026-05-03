import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opket/feat/dashboard/dashboard_new.dart';
import 'package:opket/feat/food/restaurants_page.dart';
import 'package:opket/feat/map/custom_map_page.dart';
import 'package:opket/feat/myorders/active_orders.dart';
import 'package:opket/feat/profile/profile_page.dart';
import 'package:opket/feat/ride_booking/presentation/index.dart';
import 'package:opket/feat/terms/terms_and_conditions.dart';

import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardNew());
      case RouteNames.food:
        return _createAnimatedRoute(RestaurantsPage());
      case RouteNames.profile:
        return _createAnimatedRoute(ProfilePage());
      case RouteNames.termsAndConditions:
        return _createAnimatedRoute(TermsAndConditions());
      case RouteNames.myordersActive:
        return _createAnimatedRoute(ActiveOrders());
      case RouteNames.taxi:
        return _createAnimatedRoute(RideBookingPage());
      case RouteNames.orderFoodMap:
        return CupertinoPageRoute(builder: (_) => CustomMapPage());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}

Route _createAnimatedRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
