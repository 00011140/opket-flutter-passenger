import 'package:flutter/material.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';

enum AppButtonSize { small, medium, large, extraSmall }

enum AppButtonWidth { wrap, full }

class AppIconButtonRectangle extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? iconColor;
  final IconData? icon;
  final Widget? customWidget;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;

  /// If null, uses size-based radius
  final double? borderRadius;

  /// If provided, overrides the size-based height.
  final double? height;

  /// Density system
  final AppButtonSize size;

  /// Layout system
  final AppButtonWidth width;

  const AppIconButtonRectangle({
    super.key,
    this.text,
    this.icon,
    this.iconColor = Colors.black,
    this.textColor = Colors.black,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.primary,
    this.borderRadius,
    this.customWidget,
    this.height,
    this.size = AppButtonSize.large,
    this.width = AppButtonWidth.full,
  });

  double _heightFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 30,
    AppButtonSize.small => 44,
    AppButtonSize.medium => 52,
    AppButtonSize.large => 60,
  };

  double _fontFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 12,
    AppButtonSize.small => 14,
    AppButtonSize.medium => 14,
    AppButtonSize.large => 18,
  };

  double _iconFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 18,
    AppButtonSize.small => 22,
    AppButtonSize.medium => 26,
    AppButtonSize.large => 24,
  };

  double _gapFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 3,
    AppButtonSize.small => 6,
    AppButtonSize.medium => 8,
    AppButtonSize.large => 10,
  };

  // ✅ NEW
  double _borderRadiusFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 6,
    AppButtonSize.small => 10,
    AppButtonSize.medium => 14,
    AppButtonSize.large => 16,
  };

  double _loaderSizeFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 14,
    AppButtonSize.small => 18,
    AppButtonSize.medium => 20,
    AppButtonSize.large => 22,
  };

  double _loaderStrokeFor(AppButtonSize s) => switch (s) {
    AppButtonSize.extraSmall => 1,
    AppButtonSize.small => 1.2,
    AppButtonSize.medium => 1.35,
    AppButtonSize.large => 1.5,
  };

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? _heightFor(size);
    final resolvedBorderRadius = borderRadius ?? _borderRadiusFor(size);

    final fontSize = _fontFor(size);
    final iconSize = _iconFor(size);
    final gap = _gapFor(size);
    final loaderSize = _loaderSizeFor(size);
    final loaderStroke = _loaderStrokeFor(size);

    final isFull = width == AppButtonWidth.full;

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(resolvedBorderRadius),
        ),
        overlayColor: const Color.fromARGB(10, 0, 0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: isFull
            ? Size(double.infinity, resolvedHeight)
            : Size(0, resolvedHeight),
        fixedSize: isFull ? Size(double.infinity, resolvedHeight) : null,
        padding: EdgeInsets.symmetric(horizontal: isFull ? 0 : 28),
      ),
      child: Row(
        mainAxisSize: isFull ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (customWidget != null) customWidget!,
          if (icon != null)
            Padding(
              padding: EdgeInsets.only(right: gap),
              child: Icon(icon, color: iconColor, size: iconSize),
            ),
          if (text != null)
            Text(
              text!,
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isLoading ? Colors.grey : textColor,
              ),
            ),
        ],
      ),
    );

    return SizedBox(
      height: resolvedHeight,
      width: isFull ? double.infinity : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isFull) Positioned.fill(child: button) else button,
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !isLoading,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, anim) {
                  return FadeTransition(
                    opacity: anim,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.98, end: 1.0).animate(anim),
                      child: child,
                    ),
                  );
                },
                child: isLoading
                    ? Container(
                        key: const ValueKey('loading_overlay'),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(
                            resolvedBorderRadius,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: loaderSize,
                          height: loaderSize,
                          child: CircularProgressIndicator(
                            strokeWidth: loaderStroke,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('no_overlay')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
