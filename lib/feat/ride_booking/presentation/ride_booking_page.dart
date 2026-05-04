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

          // appBar: AppBar(
          //   toolbarHeight: 80,
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          //   automaticallyImplyLeading: false,
          //   leading: null,
          //   centerTitle: true,
          //   title: AppbarLogo(),
          // ),
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
                Positioned(
                  top: AppSpacing.sm_md,
                  child: RideBookingTopTabbar(),
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
