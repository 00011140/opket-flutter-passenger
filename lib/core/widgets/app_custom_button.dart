import 'package:flutter/material.dart';

class AppCustomButton extends StatelessWidget {
  const AppCustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.enabled = true,
    this.icon,
    this.fullWidth = true,
    this.height = 48,
    this.borderRadius = 12,
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.elevation = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.textStyle,
    this.progressStrokeWidth = 2.5,
  });

  final String label;
  final VoidCallback? onPressed;

  final bool isLoading;
  final bool enabled;

  /// Optional leading icon.
  final IconData? icon;

  /// If true, button expands to max width.
  final bool fullWidth;

  final double height;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;

  final Color? backgroundColor;
  final Color? foregroundColor;

  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;

  final TextStyle? textStyle;

  final double progressStrokeWidth;

  bool get _canPress => enabled && !isLoading && onPressed != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color resolvedBg = _canPress
        ? (backgroundColor ?? theme.colorScheme.primary)
        : (disabledBackgroundColor ??
              theme.colorScheme.onSurface.withOpacity(0.12));

    final Color resolvedFg = _canPress
        ? (foregroundColor ?? theme.colorScheme.onPrimary)
        : (disabledForegroundColor ??
              theme.colorScheme.onSurface.withOpacity(0.38));

    final ButtonStyle style = ElevatedButton.styleFrom(
      elevation: elevation,
      padding: padding,
      backgroundColor: resolvedBg,
      foregroundColor: resolvedFg,
      minimumSize: Size(fullWidth ? double.infinity : 0, height),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      textStyle: textStyle ?? theme.textTheme.labelLarge,
    );

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: _canPress ? onPressed : null,
        style: style,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: isLoading
              ? _LoadingContent(
                  key: const ValueKey('loading'),
                  color: resolvedFg,
                  strokeWidth: progressStrokeWidth,
                )
              : _ButtonContent(
                  key: const ValueKey('content'),
                  label: label,
                  icon: icon,
                ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({super.key, required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) {
      return Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, color: Colors.black),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    super.key,
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
