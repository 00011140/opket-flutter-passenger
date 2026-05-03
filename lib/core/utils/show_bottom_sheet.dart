import 'package:flutter/material.dart';

void showAppModelBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    useSafeArea: true,
    isDismissible: false,
    context: context,
    isScrollControlled: true,
    enableDrag: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) {
      return child;
    },
  );
}
