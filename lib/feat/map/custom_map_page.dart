import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:opket/feat/food/cubit/order_food_cubit.dart';
import 'package:opket/feat/food/models/delivery_fee_request_body.dart';
import 'package:opket/feat/food/widgets/menu_basket.dart';
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

  /// ───────────── Lifecycle ─────────────
  @override
  void initState() {
    super.initState();

    _pinController = MapPinController();
    _map = GoogleMapsController();
    // context.read<LocationConfirmationCubit>().setData(map: _map);
    _map.init();

    _getCurrentLocation();
  }

  /// ───────────── Location ─────────────
  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition();
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
                        ctx: context,
                        bottom: 0,
                        onTap: _orderFood,
                        buttonTitle: "Tasdiqlash",
                        enableRestaurantNote: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

    final cartState = context.read<CartCubit>().state;
    context.read<OrderFoodCubit>().orderFood(cartState);
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

    if (origin == null || destination == null) return;

    final cart = context.read<CartCubit>().state;

    final requestBody = DeliveryFeeRequestBody(
      origin: Location(lat: origin.latitude, lng: origin.longitude),
      destination: Location(lat: destination.lat, lng: destination.lng),
      subtotal: cart.subtotal,
    );

    context.read<DeliveryFeeCubit>().calculateDeliveryFee(requestBody);
  }

  void onRecenter() async {
    await _map.recenterToUser();
  }
}
