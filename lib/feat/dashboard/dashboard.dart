import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/components/allow_location_dialog.dart';
import 'package:opket/components/app_container.dart';
import 'package:opket/components/authentication_wrapper.dart';
import 'package:opket/components/map_grid_loader.dart';
import 'package:opket/feat/dashboard/cubit/location_confirmation_cubit.dart';
import 'package:opket/feat/dashboard/cubit/selected_location_cubit.dart';
import 'package:opket/feat/dashboard/general_listeners.dart';
import 'package:opket/feat/dashboard/widgets/call_out_bubble.dart';
import 'package:opket/feat/dashboard/widgets/animated_map_pin.dart';
import 'package:opket/feat/balance/widgets/user_balance.dart';
import 'package:opket/feat/dashboard/widgets/my_orders_button.dart';
import 'package:opket/feat/dashboard/widgets/request_ride_sheet_new.dart';
import 'package:opket/feat/luggage/widgets/add_luggage_bottom_sheet.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/routes/route_names.dart';
import 'package:opket/services/location_service.dart';
import 'package:opket/services/socket_service.dart';
import 'package:opket/services/user_storage.dart';
import 'package:opket/utils/distaneInMeters.dart';
import 'package:opket/utils/show_bottom_sheet.dart';

import 'controllers/dashboard_map_controller.dart';
import 'controllers/map_pin_controller.dart';
import 'current_ride_bloc_listeners.dart';
import 'dashboard_bloc_listeners.dart';

class DashboardOld extends StatefulWidget {
  const DashboardOld({super.key});

  @override
  State<DashboardOld> createState() => _DashboardOldState();
}

class _DashboardOldState extends State<DashboardOld>
    with SingleTickerProviderStateMixin {
  /// ───────────── State ─────────────
  bool _isLoading = true;
  bool _showLocationHints = true;
  bool _isUserLocation = true;

  /// ───────────── Controllers ─────────────
  late final DashboardMapController _map;
  late final MapPinController _pinController;

  Timer? _hideHintTimer;

  /// ───────────── Lifecycle ─────────────
  @override
  void initState() {
    super.initState();

    _pinController = MapPinController();
    _map = DashboardMapController();
    context.read<LocationConfirmationCubit>().setData(map: _map);
    _map.init().then((v) {
      context.read<CurrentRideCubit>().restoreRide();
    });

    _initUser();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _hideHintTimer?.cancel();
    super.dispose();
  }

  void _initUser() {
    Future.delayed(const Duration(seconds: 1), () async {
      final phone = await UserStorage().getPhone();
      if (!mounted) return;

      phone == null
          ? showAppModelBottomSheet(context, const AuthenticationWrapper())
          : SocketService.instance.connect(phone);
    });
  }

  /// ───────────── Location ─────────────
  Future<void> _getCurrentLocation() async {
    try {
      if (!await LocationService.isPermissionGranted()) return;

      final position = await Geolocator.getCurrentPosition();

      setState(() {
        _map.currentLocation = LatLng(position.latitude, position.longitude);
        _map.selectedLocation = _map.currentLocation;
        _isLoading = false;
      });
    } catch (e) {}
  }

  /// ───────────── UI ─────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,

      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const MapGridLoader(),
          if (!_isLoading) _buildMap(),
          AnimatedMapPin(controller: _pinController, isLoading: _isLoading),
          _buildCallout(),
          DashboardBlocListeners(
            onDriverLocation: (location) {
              _map.updateDriverMarker(location);
              setState(() {});
            },
            onUserCreated: () async {
              _showLocaBlockedDialog();
            },
            onLocationEnabled: () {
              _getCurrentLocation();
            },
            onLuggageRequested: _showAddLuggageBottomSheet,
            onRideAccepted: (location) async {
              _map.updateDriverMarker(location);
              await _map.fitMarkersInView();
            },
            onRideRequested: () {
              _map.updateUserMarker();
              setState(() {});
            },
            clearRide: _clearRide,
          ),
          CurrentRideBlocListeners(),
          GeneralListeners(
            onOutSideOfUserLocation: () {
              // _showLocationConfirmtionSheet(context);
              setState(() {
                _showLocationHints = true;
              });
              _hideHint();
            },
          ),
          RequestRideSheetNew(onRecenter: onRecenter),
        ],
      ),
    );
  }

  void _showLocaBlockedDialog() async {
    final isPermissionGranted = await LocationService.isPermissionGranted();

    if (isPermissionGranted) return;

    Future.delayed(Duration(milliseconds: 300), () {
      showDialog(
        context: context,
        builder: (context) {
          return AllowLocationDialog(
            onLocationEnabled: () {
              _getCurrentLocation();
            },
          );
        },
      );
    });
  }

  PreferredSizeWidget _buildAppBar() {
    // final isCalling = context.select((CallCubit c) => c.state);

    return AppBar(
      clipBehavior: Clip.none,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
      ),
      leading: IconButton.filled(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 20.0,
        ),
        onPressed: () {
          Navigator.pushNamed(context, RouteNames.profile);
        },
        icon: Icon(Icons.menu_rounded, size: 28),
      ),
      actions: [MyOrdersButton(), _buildBalance()],
    );
  }

  Widget _buildMap() {
    final status = context.select((CurrentRideCubit c) => c.state.status);
    final accepted = status == RideStatus.accepted;

    return Padding(
      padding: EdgeInsets.only(
        bottom: accepted ? MediaQuery.of(context).size.height * 0.33 : 0,
      ),
      child: GoogleMap(
        rotateGesturesEnabled: !accepted,
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _map.currentLocation!,
          zoom: 19,
        ),
        markers: {
          if (_map.driverMarker != null) _map.driverMarker!,
          if (_map.selectedLocationMarker != null) _map.selectedLocationMarker!,
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        onMapCreated: _map.onMapCreated,
        onCameraMove: (p) {
          _map.updateSelectedLocation(p.target);
          context.read<SelectedLocationCubit>().setData(p.target);
        },
        onCameraMoveStarted: () {
          _pinController.lift();
        },
        onCameraIdle: () {
          _pinController.drop();
          _onCameraIdle();
        },
      ),
    );
  }

  Widget _buildCallout() {
    final status = context.select((CurrentRideCubit c) => c.state.status);
    final idle = status == RideStatus.idle;
    if (!idle) return Container();

    return Positioned(
      top: MediaQuery.of(context).size.height / 2 + 20,
      left: 0,
      right: 0,
      child: CalloutBubble(
        isUserLocation: _isUserLocation,
        showLocationHints: _showLocationHints,
      ),
    );
  }

  Widget _buildBalance() {
    return AppContainer(child: Row(children: [const UserBalance()]));
  }

  void onRecenter() async {
    setState(() => _showLocationHints = false);
    await _map.recenterToUser(context, onLocationEnabled: _getCurrentLocation);
  }

  /// ───────────── Helpers ─────────────

  void _clearRide() {
    _map.recenterToUser(context);
    _map.removeMarkers();
  }

  void _onCameraIdle() {
    final distance = distanceInMeters(
      _map.currentLocation!,
      _map.selectedLocation!,
    );

    setState(() {
      _isUserLocation = distance < 25;
      _showLocationHints = true;
    });
    context.read<LocationConfirmationCubit>().setData(
      isUserLocation: _isUserLocation,
    );
    _hideHint();
  }

  void _hideHint() {
    _hideHintTimer?.cancel();
    _hideHintTimer = Timer(
      const Duration(seconds: 4),
      () => mounted ? setState(() => _showLocationHints = false) : null,
    );
  }

  void _showAddLuggageBottomSheet(int luggageCharge, String driverId) {
    showModalBottomSheet(
      context: context,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.22),
      enableDrag: false,
      builder: (_) => AddLuggageBottomSheet(
        luggageCharge: luggageCharge,
        driverId: driverId,
      ),
    );
  }
}
