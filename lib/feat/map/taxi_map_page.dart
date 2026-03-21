import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/components/map_grid_loader.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/dashboard/controllers/dashboard_map_controller.dart';
import 'package:opket/feat/dashboard/controllers/map_pin_controller.dart';
import 'package:opket/feat/dashboard/cubit/location_confirmation_cubit.dart';
import 'package:opket/feat/dashboard/cubit/selected_location_cubit.dart';
import 'package:opket/feat/dashboard/widgets/animated_map_pin_taxi.dart';
import 'package:opket/feat/dashboard/widgets/request_ride_sheet_new.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/feat/ride/widgets/searching_drivers.dart';
import 'package:opket/services/location_service.dart';
import 'package:opket/utils/distaneInMeters.dart';

class TaxiMapPage extends StatefulWidget {
  const TaxiMapPage({super.key});

  @override
  State<TaxiMapPage> createState() => _TaxiMapPageState();
}

class _TaxiMapPageState extends State<TaxiMapPage> {
  /// ───────────── State ─────────────
  bool _isLoading = true;
  bool _isPinLoading = false;
  bool _isUserLocation = true;

  /// ───────────── Controllers ─────────────
  late final DashboardMapController _map;
  late final MapPinController _pinController;

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

    _getCurrentLocation();
  }

  /// ───────────── Location ─────────────
  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition(context);
      if (position == null) return;

      final latLng = LatLng(position.latitude, position.longitude);

      _map.currentLocation = latLng;
      _map.selectedLocation = latLng;

      setState(() {
        _isLoading = false;
      });

      // 🔥 Move camera AFTER map is ready
      _map.moveCamera(latLng);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<DeliveryFeeCubit>().reset();
        }
      },
      child: AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          extendBody: true,
          body: SafeArea(
            top: false,
            bottom: false,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const MapGridLoader(),

                if (!_isLoading)
                  GoogleMap(
                    compassEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: _map.currentLocation!,
                      zoom: 16.5,
                    ),
                    markers: {
                      if (_map.driverMarker != null) _map.driverMarker!,
                      if (_map.selectedLocationMarker != null)
                        _map.selectedLocationMarker!,
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    onMapCreated: _map.onMapCreated,
                    onCameraMove: (p) {
                      _map.updateSelectedLocation(p.target);
                    },
                    onCameraMoveStarted: () {
                      _pinController.lift();
                      setState(() {
                        _isPinLoading = true;
                      });
                    },
                    onCameraIdle: () async {
                      _pinController.drop();

                      setState(() {
                        _isPinLoading = true;
                      });

                      _onCameraIdle(); // make it async

                      setState(() {
                        _isPinLoading = false;
                      });
                    },
                  ),

                RequestRideSheetNew(onRecenter: onRecenter),
                BlocBuilder<CurrentRideCubit, CurrentRideState>(
                  builder: (context, state) {
                    final status = state.status;
                    if (status == RideStatus.pending) {
                      return Container(
                        color: const Color.fromARGB(89, 0, 0, 0),
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
                Transform.translate(
                  offset: const Offset(0, -40), // 🔥 tweak this value
                  child: AnimatedMapPinTaxi(
                    isUserLocation: _isUserLocation,
                    controller: _pinController,
                    isLoading: _isLoading || _isPinLoading,
                  ),
                ),

                BlocBuilder<CurrentRideCubit, CurrentRideState>(
                  builder: (context, state) {
                    final status = state.status;
                    if (status == RideStatus.pending) {
                      return Positioned(
                        bottom: MediaQuery.of(context).viewPadding.bottom,
                        right: 0,
                        left: 0,
                        child: SearchingDrivers(),
                      );
                    }

                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCameraIdle() {
    final distance = distanceInMeters(
      _map.currentLocation!,
      _map.selectedLocation!,
    );

    setState(() {
      _isUserLocation = distance < 25;
    });
    context.read<LocationConfirmationCubit>().setData(
      isUserLocation: _isUserLocation,
    );
    context.read<SelectedLocationCubit>().setData(_map.selectedLocation!);
  }

  void onRecenter() async {
    await _map.recenterToUser(context, onLocationEnabled: _getCurrentLocation);
  }
}
