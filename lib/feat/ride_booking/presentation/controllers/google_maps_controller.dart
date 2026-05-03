import 'dart:async';
import 'dart:math';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/models/driver_location.dart';
import 'package:opket/core/services/location_service.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_map_cubit.dart';

class GoogleMapsController {
  GoogleMapController? mapController;
  Marker? driverMarker;
  Marker? selectedLocationMarker;
  late BitmapDescriptor carIcon;
  late BitmapDescriptor pickUpLocationPin;
  String? _mapStyle;

  LatLng? currentLocation;
  LatLng? selectedLocation;

  /// ───────────── Init ─────────────
  Future<void> init() async {
    carIcon = await getScaledMarker('assets/taxi_icon.png', 95, 95);
    pickUpLocationPin = await getScaledMarker(
      'assets/pickup_location_pin.png',
      150,
      150,
    );

    await loadMapStyle();
  }

  /// ───────────── Map ─────────────
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> loadMapStyle() async {
    _mapStyle = await rootBundle.loadString('assets/map_style.json');
  }

  void setmapStyle(params) {
    if (_mapStyle != null) {
      mapController?.setMapStyle(_mapStyle);
    }
  }

  Future<void> recenterToUser(
    BuildContext context, {
    VoidCallback? onLocationEnabled,
  }) async {
    final position = await LocationService.getCurrentPosition();

    if (mapController == null || position == null) return;

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.5,
        ),
      ),
    );
  }

  Set<Marker> buildDriverMarkers(List<DriverLocation> drivers) {
    print("📍📍📍📍📍📍📍📍📍");
    print(drivers);
    return drivers.map((d) {
      return Marker(
        markerId: MarkerId("${d.latitude},${d.longitude}"),

        position: LatLng(d.latitude, d.longitude),

        rotation: d.heading ?? 0, // 🧭 rotate car

        anchor: const Offset(0.5, 0.5), // center the icon

        flat: true, // 🔥 IMPORTANT for rotation

        icon: carIcon,
        // later replace with car icon
      );
    }).toSet();
  }

  void updateSelectedLocation(LatLng target) {
    selectedLocation = target;
  }

  /// ───────────── Driver & Passenger markers ─────────────
  Marker? updateDriverMarker(DriverLocation location) {
    final latLng = LatLng(location.latitude, location.longitude);

    driverMarker = Marker(
      markerId: const MarkerId('driver'),
      position: latLng,
      rotation: location.heading ?? 0,
      icon: carIcon,
      anchor: const Offset(0.5, 0.5),
    );

    return driverMarker;
  }

  Marker? updateUserMarker() {
    if (selectedLocation == null) return null;

    selectedLocationMarker = Marker(
      markerId: const MarkerId('selected_location'),
      position: selectedLocation!,
      icon: pickUpLocationPin,
      anchor: const Offset(0.5, 0.9),
    );

    return selectedLocationMarker;
  }

  Future<BitmapDescriptor> getScaledMarker(
    String assetPath,
    double width,
    double height,
  ) async {
    final ByteData data = await rootBundle.load(assetPath);
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width.toInt(),
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final bytes = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void drawPin(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    final radius = size / 2;
    final pinHeight = size * 1.3;

    // Top circle
    path.addOval(
      Rect.fromCircle(center: Offset(center.dx, center.dy), radius: radius),
    );

    // Bottom pointer
    path.moveTo(center.dx - radius * 0.6, center.dy + radius * 0.5);
    path.quadraticBezierTo(
      center.dx,
      center.dy + pinHeight,
      center.dx + radius * 0.6,
      center.dy + radius * 0.5,
    );

    path.close();
    canvas.drawPath(path, paint);

    // Inner hole
    canvas.drawCircle(center, radius * 0.45, Paint()..color = Colors.black);
  }

  Future<BitmapDescriptor> createPinWithLabel(
    String text, {
    double scale = 3.0,
  }) async {
    const paddingX = 12.0;
    const paddingY = 8.0;
    const fontSize = 14.0;

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(scale);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: fontSize, color: Colors.black),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final labelWidth = textPainter.width + paddingX * 2;
    final labelHeight = textPainter.height + paddingY * 2;

    const pinSize = 40.0;
    const spacing = 12.0;

    // Draw pin
    drawPin(
      canvas,
      Offset(labelWidth / 2, pinSize / 2),
      pinSize,
      const Color(0xFFF25C54), // same red as image
    );

    // Label background
    final bgPaint = Paint()..color = const Color.fromARGB(221, 255, 255, 255);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, pinSize + spacing, labelWidth, labelHeight),
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect, bgPaint);

    // Label text
    textPainter.paint(canvas, Offset(paddingX, pinSize + spacing + paddingY));

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (labelWidth * scale).toInt(),
      ((pinSize + spacing + labelHeight) * scale).toInt(),
    );

    final bytes = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  void removeMarkers() {
    driverMarker = null;
    selectedLocationMarker = null;
  }

  /// ───────────── Assets ─────────────
  LatLngBounds boundsFromMarkers(LatLng a, LatLng b) {
    final southWest = LatLng(
      min(a.latitude, b.latitude),
      min(a.longitude, b.longitude),
    );
    final northEast = LatLng(
      max(a.latitude, b.latitude),
      max(a.longitude, b.longitude),
    );
    return LatLngBounds(southwest: southWest, northeast: northEast);
  }

  void _updateCameraBounds(LatLng driver, LatLng pickup) {
    final double southWestLat = math.min(driver.latitude, pickup.latitude);
    final double southWestLng = math.min(driver.longitude, pickup.longitude);
    final double northEastLat = math.max(driver.latitude, pickup.latitude);
    final double northEastLng = math.max(driver.longitude, pickup.longitude);

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(southWestLat, southWestLng),
      northeast: LatLng(northEastLat, northEastLng),
    );

    final double latDiff = (northEastLat - southWestLat).abs();
    final double lngDiff = (northEastLng - southWestLng).abs();

    // If route is more vertical → increase padding
    // If route is more horizontal → reduce padding
    final double padding = latDiff > lngDiff ? 250 : 80;

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, padding));
  }

  Future<void> moveCamera(LatLng target) async {
    if (mapController == null) return;

    await mapController!.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 19)),
    );
  }

  /// Fits both selectedLocation and driverMarker in view, with bottom padding
  Future<void> fitMarkersInView({double bottomPadding = 120}) async {
    if (selectedLocation == null ||
        driverMarker == null ||
        mapController == null)
      return;

    _updateCameraBounds(selectedLocation!, driverMarker!.position);
  }
}
