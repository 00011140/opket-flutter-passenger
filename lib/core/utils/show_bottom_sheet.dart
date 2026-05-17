import 'package:flutter/material.dart';

void showAppModelBottomSheet(BuildContext context, Widget child) {
  showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) {
      return child;
    },
  );
}
