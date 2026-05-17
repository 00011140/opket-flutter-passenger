import 'package:flutter/material.dart';
import 'package:opket/core/theme/spacing.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final bool shadow;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? width;
  final EdgeInsets? margin;
  final Color? bgColor;
  final Gradient? gradient;
  final BoxConstraints? constraints;
  final BoxBorder? border;
  final Function()? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.border,
    this.height,
    this.onTap,
    this.borderRadius,
    this.bgColor,
    this.gradient,
    this.constraints,
    this.padding,
    this.margin,
    this.width = double.maxFinite,
    this.shadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      curve: Curves.easeOut,
      constraints: constraints,
      clipBehavior: Clip.hardEdge,
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? AppSpacing.md_lg),
        color: bgColor ?? Theme.of(context).cardColor.withOpacity(0.7),
        gradient: gradient,
        border: border,
        boxShadow: shadow
            ? const [
                BoxShadow(
                  color: Color.fromARGB(33, 0, 0, 0),
                  spreadRadius: -9,
                  blurRadius: 20,
                  offset: Offset(1, 2),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: onTap,
          child: Container(
            padding:
                padding ??
                EdgeInsets.symmetric(
                  vertical: AppSpacing.md_lg,
                  horizontal: AppSpacing.md,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
