import 'package:flutter/material.dart';
import 'package:opket/core/theme/spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 24,
    this.onTap,
    this.boxShadow = true,
    this.disabled = false,
    this.fullHeight = false,
    this.isFull = false,
    this.isLoading = false,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool boxShadow;
  final double borderRadius;
  final bool disabled;
  final bool isFull;
  final bool isLoading;
  final bool fullHeight;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: fullHeight ? double.infinity : null,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          width: isFull ? double.infinity : null,
          margin: margin,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            boxShadow: !boxShadow
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFF0F172A05).withOpacity(
                        0.02,
                      ), // #0F172A08 = 3% opacity = 0x08, but Flutter uses AARRGGBB so it's 0x0D for ~5% approximation
                      offset: const Offset(0, 4), // x: 0, y: 4
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: const Color(
                        0xFF0F172A08,
                      ).withOpacity(0.03), // #0F172A14 = 8% opacity
                      offset: const Offset(0, 12), // x: 0, y: 12
                      blurRadius: 16,
                      spreadRadius: 4,
                    ),
                  ],
            color: color ?? Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          ),
          // child: child,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // splashFactory: NoSplash.splashFactory,
              onTap: onTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: padding ?? EdgeInsets.all(AppSpacing.md_lg),
                    child: child,
                  ),
                  if (isLoading)
                    Positioned(
                      right: 0,
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        // color: const Color.fromARGB(88, 0, 0, 0),
                        child: Center(
                          child: SizedBox(
                            height: 25,
                            width: 25,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
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
}
