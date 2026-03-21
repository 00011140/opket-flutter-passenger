import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';

import 'app_icon_button_rectangle.dart';

import 'dart:async';

class EnableLocationServicesDialog extends StatefulWidget {
  const EnableLocationServicesDialog({super.key});

  @override
  State<EnableLocationServicesDialog> createState() =>
      _EnableLocationServicesDialogState();
}

class _EnableLocationServicesDialogState
    extends State<EnableLocationServicesDialog>
    with WidgetsBindingObserver {
  StreamSubscription<ServiceStatus>? _serviceStatusSub;
  bool _checking = false;
  bool _closed = false; // ✅ prevents double-pop

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _recheckAndMaybeClose();

    _serviceStatusSub = Geolocator.getServiceStatusStream().listen((_) {
      _recheckAndMaybeClose();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _serviceStatusSub?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recheckAndMaybeClose();
    }
  }

  Future<void> _closeDialogOnce() async {
    if (_closed || !mounted) return;
    _closed = true;

    // stop listeners immediately so they can't trigger another pop
    await _serviceStatusSub?.cancel();
    _serviceStatusSub = null;

    // pop after current frame to avoid popping during lifecycle callbacks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<LocationCubit>().setData(true);
      final nav = Navigator.of(context, rootNavigator: true);
      if (nav.canPop()) nav.pop(true);
    });
  }

  Future<void> _recheckAndMaybeClose() async {
    if (_checking || _closed) return;
    _checking = true;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      final permission = await Geolocator.checkPermission();

      final permissionOk =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;

      if (serviceEnabled && permissionOk) {
        await _closeDialogOnce();
      }
    } finally {
      _checking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 45, color: Colors.grey),
            SizedBox(height: AppSpacing.md),
            const Text(
              "Joylashuv (Lokatsiya) ni yoqing",
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            const Text(
              "Siz turgan manzilni aniqlashimiz uchun, iltimos telefoningizdagi joylashuv/lokatsiyani yoqing",
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            AppIconButtonRectangle(
              text: "Yoqish",
              onPressed: () async => Geolocator.openLocationSettings(),
              backgroundColor: const Color(0xFFFFE711),
              textColor: Colors.black,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}
