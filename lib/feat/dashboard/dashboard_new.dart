import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/socket_service.dart';
import 'package:opket/feat/report/index.dart';
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
  bool _authSheetShown = false;
  StreamSubscription? _forceLogoutSub;

  @override
  void initState() {
    super.initState();
    _forceLogoutSub = SocketService.instance.onForceLogout.listen((_) {
      if (!mounted) return;
      context.read<AuthCubit>().logout();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (context.read<AuthCubit>().state is UnAuthenticated) {
        _showAuthSheet();
      }
    });
  }

  @override
  void dispose() {
    _forceLogoutSub?.cancel();
    super.dispose();
  }

  void _showAuthSheet() {
    if (_authSheetShown || !mounted) return;
    _authSheetShown = true;
    showAppModelBottomSheet(context, const AuthPage());
  }

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
    print("🥰🥰🥰🥰");
    print(state);
    if (state is Authenticated) {
      _authSheetShown = false;
      sl<ReportAppInfo>()(null);
    } else if (state is UnAuthenticated) {
      _showAuthSheet();
    }
  }
}
