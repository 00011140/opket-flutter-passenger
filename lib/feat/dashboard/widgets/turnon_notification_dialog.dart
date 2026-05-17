import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/report/index.dart';

class TurnonNotificationDialog extends StatefulWidget {
  const TurnonNotificationDialog({super.key, this.description});
  final String? description;

  @override
  State<TurnonNotificationDialog> createState() =>
      _TurnonNotificationDialogState();
}

class _TurnonNotificationDialogState extends State<TurnonNotificationDialog>
    with WidgetsBindingObserver {
  bool _closed = false;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Check immediately when dialog shows
    _recheckAndMaybeClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // When user returns from system permission sheet / Settings
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recheckAndMaybeClose();
    }
  }

  Future<void> _closeDialogOnce([bool result = true]) async {
    if (_closed || !mounted) return;
    _closed = true;

    // Pop after frame to avoid popping during lifecycle callbacks
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final nav = Navigator.of(context, rootNavigator: true);
      if (nav.canPop()) nav.pop(result);
    });
  }

  Future<void> _recheckAndMaybeClose() async {
    if (_checking || _closed) return;
    _checking = true;
    try {
      final allowed = await AwesomeNotifications().isNotificationAllowed();
      if (allowed) {
        sl<ReportAppInfo>()(null);
        await _closeDialogOnce(true);
      }
    } finally {
      _checking = false;
    }
  }

  Future<void> _requestNotificationPermission() async {
    // First, ask using the OS permission prompt (if possible)
    final result = await AwesomeNotifications()
        .requestPermissionToSendNotifications();

    if (result) {
      await _closeDialogOnce(true);
      return;
    }

    // If denied (especially on iOS), user must enable from Settings.
    // Optional: open settings to help them.
    // await AwesomeNotifications().openAppSettings();
    // When user comes back, didChangeAppLifecycleState(resumed) will re-check.
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
                Image.asset("assets/push-notifications.png", width: 60),
                const Text(
                  "Bildirishnomani yoqing",
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  widget.description ??
                      "Sizga muhim xabarlar yubora olishmiz uchun, iltimos bildirishnomaga ruxsat bering!",
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
                  onPressed: _requestNotificationPermission,
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
