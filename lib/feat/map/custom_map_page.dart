import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/core/widgets/app_container.dart';
import 'package:opket/core/widgets/custom_back_button.dart';
import 'package:opket/core/widgets/map_grid_loader.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/dashboard/controllers/dashboard_map_controller.dart';
import 'package:opket/feat/dashboard/controllers/map_pin_controller.dart';
import 'package:opket/feat/dashboard/widgets/animated_map_pin.dart';
import 'package:opket/feat/dashboard/widgets/recenter_button.dart';
import 'package:opket/feat/dashboard/widgets/turnon_notification_dialog.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/current_restaurant_cubit.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/app/router/route_names.dart';
import 'package:opket/feat/food/cubit/order_food_cubit.dart';
import 'package:opket/feat/food/models/delivery_fee_request_body.dart';
import 'package:opket/feat/food/widgets/menu_basket.dart';
import 'package:opket/feat/food/widgets/order_food_success.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/services/order_local_storage.dart';
import 'package:opket/core/services/location_service.dart';
import 'package:opket/core/utils/distaneInMeters.dart';

class CustomMapPage extends StatefulWidget {
  const CustomMapPage({super.key});

  @override
  State<CustomMapPage> createState() => _CustomMapPageState();
}

class _CustomMapPageState extends State<CustomMapPage> {
  /// ───────────── State ─────────────
  bool _isLoading = true;
  bool _isPinLoading = false;
  bool _isUserLocation = true;

  /// ───────────── Controllers ─────────────
  late final GoogleMapsController _map;
  late final MapPinController _pinController;

  // Keeps _map.currentLocation in sync with the device's real GPS position
  // so that _onCameraIdle()'s distance check stays accurate while the user
  // is walking. Updates are silent (no setState) because currentLocation is
  // read lazily only when the camera becomes idle.
  StreamSubscription<Position>? _locationStreamSub;

  /// ───────────── Lifecycle ─────────────
  @override
  void initState() {
    super.initState();

    _pinController = MapPinController();
    _map = GoogleMapsController();
    // context.read<LocationConfirmationCubit>().setData(map: _map);
    _map.init().then((_) => _getCurrentLocation());
  }

  @override
  void dispose() {
    _locationStreamSub?.cancel();
    super.dispose();
  }

  /// ───────────── Location ─────────────
  Future<void> _getCurrentLocation() async {
    try {
      // Phase 1: show the map immediately using the OS-cached last-known
      // position (returns in < 100 ms, no GPS wait required).
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (mounted && lastKnown != null) {
        final latLng = LatLng(lastKnown.latitude, lastKnown.longitude);
        _map.currentLocation = latLng;
        _map.selectedLocation = latLng;
        setState(() => _isLoading = false);
      }

      // Phase 2: refine with a stable GPS fix in the background.
      Position? position = await LocationService.getStablePosition();
      position ??= await LocationService.getCurrentPosition();

      if (!mounted || position == null) return;

      final latLng = LatLng(position.latitude, position.longitude);
      _map.currentLocation = latLng;
      _map.selectedLocation = latLng;

      if (_isLoading) {
        // No last-known was available; show the map now.
        setState(() => _isLoading = false);
      } else {
        // Map is already visible; animate to the refined position.
        await _map.moveCamera(latLng);
      }

      _startLocationTracking();
    } catch (e) {}
  }

  void _startLocationTracking() {
    _locationStreamSub?.cancel();
    _locationStreamSub = LocationService.getAccuratePositionStream().listen((
      position,
    ) {
      if (!mounted) {
        _locationStreamSub?.cancel();
        return;
      }
      // Update reference point used by _onCameraIdle() distance check.
      // No setState — currentLocation is read lazily when camera idles,
      // so there is no UI update needed here.
      _map.currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderFoodCubit, OrderFoodState>(
      listener: (context, state) {
        print("🤪🤪🤪🤪");
        print(state);
        if (state is OrderFoodSuccess) {
          OrderLocalStorage.saveOrder(state.order);
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(RouteNames.dashboard, (route) => false);
          Navigator.of(context).pushNamed(RouteNames.myordersActive);
          _showOrderFoodSuccessDialog(context);
        } else if (state is OrderFoodError) {
          print(state.message);
        }
      },
      child: PopScope(
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            context.read<DeliveryFeeCubit>().reset();
          }
        },
        child: AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white,
            systemStatusBarContrastEnforced: false,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            extendBody: true,
            appBar: AppBar(
              leading: CustomBackButton(),
              title: Text(
                "Yetkazish manzilini tanlang",
                style: TextStyle(fontSize: 20),
              ),
            ),
            body: SafeArea(
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
                        // context.read<SelectedLocationCubit>().setData(p.target);
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
                  Transform.translate(
                    offset: const Offset(0, -40), // 🔥 tweak this value

                    child: AnimatedMapPin(
                      controller: _pinController,
                      isLoading: _isLoading || _isPinLoading,
                    ),
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentGeometry.centerRight,
                          child: AppContainer(
                            child: RecenterButton(onTap: onRecenter),
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        MenuBasket(
                          bottom: 0,
                          onTap: _orderFood,
                          buttonTitle: "Tasdiqlash",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderFoodSuccessDialog(BuildContext context) {
    showDialog(context: context, builder: (_) => OrderFoodSuccessDialog());
  }

  void _orderFood() async {
    const description =
        "Buyurtmangiz holati haqida sizga xabar berib turishimiz uchun iltimos bildirishnomalarni yoqing";
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (!isAllowed) {
      showDialog(
        context: context,
        builder: (context) {
          return TurnonNotificationDialog(description: description);
        },
      );
      return;
    }

    final feeState = context.read<DeliveryFeeCubit>().state;
    final fee = feeState is DeliveryFeeLoaded ? feeState.data : null;
    final cartState = context.read<CartCubit>().state.copyWith(
      deliveryFee: fee,
    );
    final location = _map.selectedLocation!;

    context.read<OrderFoodCubit>().orderFood(
      cartState,
      location.latitude,
      location.longitude,
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
    // context.read<LocationConfirmationCubit>().setData(
    //   isUserLocation: _isUserLocation,
    // );
    _calculateDeliveryFee();
    // _hideHint();
  }

  void _calculateDeliveryFee() {
    final restaurant = context.read<CurrentRestaurantCubit>().state;
    final origin = _map.selectedLocation;
    final destination = restaurant.location;

    if (origin == null ||
        destination == null ||
        destination.lat == 0 && destination.lng == 0)
      return;

    final cart = context.read<CartCubit>().state;

    final requestBody = DeliveryFeeRequestBody(
      origin: Location(lat: origin.latitude, lng: origin.longitude),
      destination: Location(lat: destination.lat, lng: destination.lng),
      subtotal: cart.subtotal,
      freeOverAmount: restaurant.delivery.freeOverAmount,
    );

    context.read<DeliveryFeeCubit>().calculateDeliveryFee(requestBody);
  }

  void onRecenter() async {
    await _map.recenterToUser();
  }
}
