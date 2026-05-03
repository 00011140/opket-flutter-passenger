import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/dashboard/cubit/location_cubit.dart';

class AllowLocationDialog extends StatefulWidget {
  const AllowLocationDialog({super.key, this.deniedForever = false});
  final bool deniedForever;

  @override
  State<AllowLocationDialog> createState() => _AllowLocationDialogState();
}

class _AllowLocationDialogState extends State<AllowLocationDialog>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("RESUMED");
      context.read<LocationCubit>().checkLocationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Joylashuvga ruxsat bering",
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.md),
                const Text(
                  "Siz turgan manzilni aniqlashimiz uchun joylashuvga ruxsat bering!",
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
                  text: "Ruxsat berish",
                  onPressed: () {
                    context.read<LocationCubit>().checkLocationPermission();
                    if (widget.deniedForever) {
                      Geolocator.openLocationSettings();
                      return;
                    }
                    Navigator.pop(context);
                  },
                  backgroundColor: const Color(0xFFFFE711),
                  textColor: Colors.black,
                  height: 55,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
