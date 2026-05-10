import 'package:flutter/material.dart';
import 'package:opket/core/services/app_update_service.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';

class AppUpdateAvailable extends StatefulWidget {
  const AppUpdateAvailable({super.key});

  @override
  State<AppUpdateAvailable> createState() => _AppUpdateAvailableState();
}

class _AppUpdateAvailableState extends State<AppUpdateAvailable> {
  bool _updateAvailable = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final available = await AppUpdateService.isUpdateAvailable();
    if (!mounted || !available) return;
    setState(() => _updateAvailable = true);
    _showBottomSheet();
  }

  void _showBottomSheet() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        builder: (_) => _UpdateBottomSheet(
          onYes: () {
            Navigator.pop(context);
            _doUpdate();
          },
          onNo: () => Navigator.pop(context),
        ),
      );
    });
  }

  Future<void> _doUpdate() async {
    setState(() => _isUpdating = true);
    await AppUpdateService.openStore();
    if (mounted) setState(() => _isUpdating = false);
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class _UpdateBottomSheet extends StatelessWidget {
  const _UpdateBottomSheet({required this.onYes, required this.onNo});

  final VoidCallback onYes;
  final VoidCallback onNo;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.md_lg,
        0,
        AppSpacing.md_lg,
        AppSpacing.md + bottom,
      ),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Yangilanish mavjud",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),

            const Text(
              "Ilovaga yangi funksiyalar qo'shildi, yangilashni hohlaysizmi?",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "YO'Q",
                    onPressed: onNo,
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "HA",
                    onPressed: onYes,
                    backgroundColor: const Color(0xFFFFE711),
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
