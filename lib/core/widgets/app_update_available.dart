import 'package:flutter/material.dart';
import 'package:opket/core/models/update_info.dart';
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

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final info = await AppUpdateService.checkUpdate();
    if (!mounted || !info.isAvailable) return;
    _showBottomSheet(info);
  }

  void _showBottomSheet(UpdateInfo info) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isDismissible: !info.isMandatory,
        enableDrag: !info.isMandatory,
        backgroundColor: Colors.transparent,
        builder: (_) => PopScope(
          canPop: !info.isMandatory,
          child: _UpdateBottomSheet(
            isMandatory: info.isMandatory,
            onUpdate: () {
              if (!info.isMandatory) Navigator.pop(context);
              _doUpdate(isMandatory: info.isMandatory);
            },
            onLater: info.isMandatory ? null : () => Navigator.pop(context),
          ),
        ),
      );
    });
  }

  Future<void> _doUpdate({required bool isMandatory}) async {
    await AppUpdateService.openStore(isMandatory: isMandatory);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _UpdateBottomSheet extends StatelessWidget {
  const _UpdateBottomSheet({
    required this.isMandatory,
    required this.onUpdate,
    this.onLater,
  });

  final bool isMandatory;
  final VoidCallback onUpdate;
  final VoidCallback? onLater;

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
            Text(
              isMandatory ? "Yangilanish majburiy" : "Yangilanish mavjud",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              isMandatory
                  ? "Ilovaning yangi versiyasi chiqdi. Davom etish uchun yangilang."
                  : "Ilovaga yangi funksiyalar qo'shildi, yangilashni hohlaysizmi?",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            if (isMandatory)
              SizedBox(
                width: double.infinity,
                child: AppIconButtonRectangle(
                  text: "YANGILASH",
                  onPressed: onUpdate,
                  backgroundColor: const Color(0xFFFFE711),
                  textColor: Colors.black,
                  height: 55,
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: AppIconButtonRectangle(
                      text: "YO'Q",
                      onPressed: onLater!,
                      backgroundColor: Colors.grey.shade200,
                      textColor: Colors.black,
                      height: 55,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppIconButtonRectangle(
                      text: "HA",
                      onPressed: onUpdate,
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
