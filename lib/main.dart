import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/toast_service.dart';
import 'package:opket/core/theme.dart';
import 'package:opket/cubit/auth_cubit.dart';
import 'package:opket/cubit/cool_down_cubit.dart';
import 'package:opket/cubit/create_user_cubit.dart';
import 'package:opket/cubit/premium_taxi_cubit.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/cubit/services_cubit.dart';
import 'package:opket/di/sl.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/balance/cubit/pay_fare_cubit.dart';
import 'package:opket/feat/dashboard/cubit/call_cubit.dart';
import 'package:opket/feat/dashboard/cubit/contact_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_confirmation_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';
import 'package:opket/feat/dashboard/cubit/selected_location_cubit.dart';
import 'package:opket/feat/dashboard/dashboard_new.dart';
import 'package:opket/feat/fare_by_options/fare_cubit.dart';
import 'package:opket/feat/feature_flag/feature_flag_cubit.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/current_order_cubit.dart';
import 'package:opket/feat/food/cubit/current_restaurant_cubit.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/feat/food/cubit/food_categories_cubit.dart';
import 'package:opket/feat/food/cubit/menu_items_cubit.dart';
import 'package:opket/feat/food/cubit/order_food_cubit.dart';
import 'package:opket/feat/food/cubit/restaurant_categories_cubit.dart';
import 'package:opket/feat/food/cubit/restaurants_cubit.dart';
import 'package:opket/feat/luggage/cubit/luggage_cubit.dart';
import 'package:opket/feat/map/taxi_map_page.dart';
import 'package:opket/feat/myorders/cubit/active_orders_cubit.dart';
import 'package:opket/feat/myorders/cubit/get_active_orders_cubit.dart';
import 'package:opket/feat/profile/cubit/delete_account_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/driver_location_cubit.dart';
import 'package:opket/feat/ride/cubit/spam_guard_cubit.dart';
import 'package:opket/feat/ride/services/ride_persist_status.dart';
import 'package:opket/feat/ride/services/spam_guard_repository.dart';
import 'package:opket/routes/app_router.dart';
import 'package:opket/services/referral_service.dart';
import 'services/connectivity_service.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SelectedLocationCubit()),
        BlocProvider(create: (_) => ServicesCubit()),
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => CallCubit()),
        BlocProvider(create: (_) => FareCubit()),
        BlocProvider(create: (_) => FeatureFlagCubit()),
        BlocProvider(create: (_) => CurrentOrderCubit()),
        BlocProvider(create: (_) => LocationConfirmationCubit()),

        BlocProvider(
          create: (context) => PremiumTaxiCubit(context.read<FareCubit>()),
        ),
        BlocProvider(
          create: (context) => CurrentRideCubit(
            callCubit: context.read<CallCubit>(),
            premiumTaxiCubit: context.read<PremiumTaxiCubit>(),
            ridePersistService: RidePersistService(),
          ),
        ),
        BlocProvider(
          create: (context) => CoolDownCubit(context.read<CurrentRideCubit>()),
        ),
        BlocProvider(
          create: (context) => RideCubit(
            premiumTaxiCubit: context.read<PremiumTaxiCubit>(),
            selectedLocationCubit: context.read<SelectedLocationCubit>(),
            callCubit: context.read<CallCubit>(),
            currentRideCubit: context.read<CurrentRideCubit>(),
            coolDownCubit: context.read<CoolDownCubit>(),
            fareCubit: context.read<FareCubit>(),
          ),
        ),

        BlocProvider(create: (_) => DeliveryFeeCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => CurrentRestaurantCubit()),

        BlocProvider(
          create: (context) => CreateUserCubit(context.read<AuthCubit>()),
        ),
        BlocProvider(create: (_) => DeleteAccountCubit()),
        BlocProvider(create: (_) => BalanceCubit()),
        BlocProvider(create: (_) => PayFareCubit()),
        BlocProvider(create: (_) => LuggageCubit()),
        BlocProvider(create: (_) => ContactCubit()),
        BlocProvider(create: (_) => LocationCubit()),
        BlocProvider(create: (_) => FoodCategoriesCubit()),
        BlocProvider(create: (_) => RestaurantsCubit()),
        BlocProvider(create: (_) => MenuItemsCubit()),
        BlocProvider(create: (_) => ActiveOrdersCubit()),
        BlocProvider(create: (context) => OrderFoodCubit()),
        BlocProvider(create: (context) => GetActiveOrdersCubit()),
        BlocProvider(
          create: (context) => SpamGuardCubit(
            repo: SpamGuardRepository(),
            currentRideCubit: context.read<CurrentRideCubit>(),
          )..init(),
        ),
        BlocProvider(create: (_) => RestaurantCategoriesCubit()),
        BlocProvider(
          create: (context) =>
              DriverLocationCubit(context.read<CurrentRideCubit>()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<bool> _subscription;

  @override
  void initState() {
    super.initState();
    ReferralService.init();
    _subscription = ConnectivityService().connectionStream.listen((
      hasInternet,
    ) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!hasInternet) {
          ToastService.showPersistent("Internet aloqasi yo'q");
        } else {
          ToastService.hide();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      home: DashboardNew(),
      // home: TaxiMapPage(),
      onGenerateRoute: AppRouter.generateRoute,
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
