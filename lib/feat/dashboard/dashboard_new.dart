import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/toast_service.dart';
import 'package:opket/core/cubit/connectivity_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/auth_cubit.dart';
import 'package:opket/feat/auth/presentation/auth_page.dart';
import 'package:opket/feat/dashboard/widgets/dashboard_taxi_button.dart';
import 'package:opket/feat/food/restaurants_page.dart';
import 'package:opket/core/utils/show_bottom_sheet.dart';
import 'package:opket/feat/ride_booking/presentation/index.dart';

class DashboardNew extends StatefulWidget {
  const DashboardNew({super.key});

  @override
  State<DashboardNew> createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(listener: _listenAuthCubit),
        BlocListener<ConnectivityCubit, bool>(
          listener: _listenConnectivityCubit,
        ),
      ],
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
        ),
        child: Scaffold(
          // floatingActionButton: TaxiButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Column(children: [Expanded(child: RideBookingPage())]),
          ),
        ),
      ),
    );
  }

  void _listenConnectivityCubit(BuildContext c, bool isConnected) {
    if (!isConnected) {
      ToastService.showPersistent("Internet aloqasi yo'q");
    } else {
      ToastService.hide();
    }
  }

  void _listenAuthCubit(BuildContext c, AuthState state) {
    if (state is UnAuthenticated) {
      Future.delayed(const Duration(seconds: 1), () async {
        showAppModelBottomSheet(context, const AuthPage());
      });
    }
  }
}
