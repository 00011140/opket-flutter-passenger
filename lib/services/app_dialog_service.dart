import 'package:flutter/material.dart';
import 'package:opket/components/allow_location_dialog.dart';
import 'package:opket/components/enable_location_services_dialog.dart';

class AppDialogService {
  static void showEnableLocationDialog(
    BuildContext context, {
    VoidCallback? onLocationEnabled,
  }) async {
    showDialog(
      context: context,
      builder: (context) {
        return AllowLocationDialog(
          onLocationEnabled: onLocationEnabled ?? () {},
        );
      },
    );
  }

  static void showEnableLocationServicesDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (context) {
        return EnableLocationServicesDialog();
      },
    );
  }
}
