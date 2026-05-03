import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/cubit/connectivity_cubit.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/cubit/services_cubit.dart';
import 'package:opket/feat/active_ride/index.dart';
import 'package:opket/feat/auth/presentation/cubit/auth_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/balance/cubit/pay_fare_cubit.dart';
import 'package:opket/feat/dashboard/cubit/contact_cubit.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';
import 'package:opket/feat/dashboard/cubit/selected_location_cubit.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/current_order_cubit.dart';
import 'package:opket/feat/food/cubit/current_restaurant_cubit.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/feat/food/cubit/food_categories_cubit.dart';
import 'package:opket/feat/food/cubit/menu_items_cubit.dart';
import 'package:opket/feat/food/cubit/order_food_cubit.dart';
import 'package:opket/feat/food/cubit/restaurant_categories_cubit.dart';
import 'package:opket/feat/food/cubit/restaurants_cubit.dart';
import 'package:opket/feat/myorders/cubit/active_orders_cubit.dart';
import 'package:opket/feat/myorders/cubit/get_active_orders_cubit.dart';
import 'package:opket/feat/profile/cubit/delete_account_cubit.dart';
import 'package:opket/feat/active_ride/presentation/cubit/driver_location_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/location_confirmation_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_booking_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_map_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_validation_cubit.dart';
import 'package:opket/feat/ride_options/index.dart';

class AppProviders extends StatelessWidget {
  final Widget child;

  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ConnectivityCubit>()..init()),
        BlocProvider(create: (_) => sl<GetCurrentRideCubit>()),
        BlocProvider(create: (_) => sl<RideOptionsCubit>()),
        BlocProvider(create: (_) => sl<SelectedRideOptionsCubit>()),
        BlocProvider(create: (_) => sl<RideBookingCubit>()),
        BlocProvider(create: (_) => sl<RideValidationCubit>()),
        BlocProvider(create: (_) => sl<ActiveRideCubit>()),
        BlocProvider(create: (_) => sl<LocationConfirmationCubit>()),
        BlocProvider(create: (_) => sl<RideMapCubit>()..init()),
        BlocProvider(create: (_) => sl<AuthCubit>()..init()),
        BlocProvider(create: (_) => sl<OtpCubit>()),
        BlocProvider(create: (_) => SelectedLocationCubit()),
        BlocProvider(create: (_) => sl<ServicesCubit>()..init()),
        BlocProvider(create: (_) => CurrentOrderCubit()),
        BlocProvider(create: (_) => DeliveryFeeCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => CurrentRestaurantCubit()),
        BlocProvider(create: (_) => DeleteAccountCubit()),
        BlocProvider(create: (_) => BalanceCubit()),
        BlocProvider(create: (_) => PayFareCubit()),
        BlocProvider(create: (_) => ContactCubit()),
        BlocProvider(create: (_) => LocationCubit()),
        BlocProvider(create: (_) => FoodCategoriesCubit()),
        BlocProvider(create: (_) => RestaurantsCubit()),
        BlocProvider(create: (_) => MenuItemsCubit()),
        BlocProvider(create: (_) => ActiveOrdersCubit()),
        BlocProvider(create: (context) => OrderFoodCubit()),
        BlocProvider(create: (context) => GetActiveOrdersCubit()),
        BlocProvider(create: (_) => RestaurantCategoriesCubit()),
        BlocProvider(
          create: (context) =>
              DriverLocationCubit(context.read<ActiveRideCubit>()),
        ),
      ],
      child: child,
    );
  }
}
