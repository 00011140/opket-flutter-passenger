import 'package:flutter/material.dart';
import 'package:opket/core/spacing.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    super.key,
    required this.child,
    this.bottom = false,
    this.top = false,
  });
  final Widget child;
  final bool bottom;
  final bool top;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.only(
        left: AppSpacing.sm_md,
        right: AppSpacing.sm_md,
        top: top ? AppSpacing.sm_md : 0,
        bottom: bottom ? AppSpacing.sm_md : 0,
      ),
      child: child,
    );
  }
}
