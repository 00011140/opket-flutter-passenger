import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/authentication_wrapper.dart';
import 'package:opket/cubit/auth_cubit.dart';
import 'package:opket/cubit/services_cubit.dart';
import 'package:opket/feat/dashboard/widgets/dashboard_taxi_button.dart';
import 'package:opket/feat/food/restaurants_page.dart';
import 'package:opket/utils/show_bottom_sheet.dart';

class DashboardNew extends StatefulWidget {
  const DashboardNew({super.key});

  @override
  State<DashboardNew> createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew> {
  @override
  void initState() {
    context.read<AuthCubit>().init();
    context.read<ServicesCubit>().init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: _listenAuthCubit,
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
          floatingActionButton: TaxiButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            child: Column(children: [Expanded(child: RestaurantsContent())]),
          ),
        ),
      ),
    );
  }

  void _listenAuthCubit(BuildContext c, AuthState state) {
    if (state is UnAuthenticated) {
      Future.delayed(const Duration(seconds: 1), () async {
        showAppModelBottomSheet(context, const AuthenticationWrapper());
      });
    }
  }
}
