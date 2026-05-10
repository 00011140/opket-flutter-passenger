part of 'index.dart';

class RideBookingPage extends StatefulWidget {
  const RideBookingPage({super.key});

  @override
  State<RideBookingPage> createState() => _RideBookingPageState();
}

class _RideBookingPageState extends State<RideBookingPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    // ActiveRideCacheService.clearRideState();
    context.read<RideMapCubit>().initAnimation(this);
    super.initState();
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
          systemNavigationBarColor: Color.fromRGBO(0, 0, 0, 0),
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RideBookingMap(),
                RideBookingOverlay(),
                RideBookingSheet(),
                RideEffectListener(),
                RideBookingListener(),
                MapPin(),
                AppUpdateAvailable(),
                BlocBuilder<ActiveRideCubit, ActiveRideState>(
                  builder: (context, state) {
                    return _AnimatedTopWidget(
                      visible: state.status == RideStatus.idle,
                      child: FoodLogo(),
                    );
                  },
                ),
              ],
            ),
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

class _AnimatedTopWidget extends StatelessWidget {
  final bool visible;
  final Widget child;

  const _AnimatedTopWidget({required this.visible, required this.child});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      top: visible ? topPadding : -100, // slide up when hidden

      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: visible ? 1 : 0,
        child: child,
      ),
    );
  }
}
