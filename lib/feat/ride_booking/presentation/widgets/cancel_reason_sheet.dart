import 'package:flutter/material.dart';
import 'package:opket/core/services/cancel_reasons_service.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/widgets/app_button_rectangle.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';

/// Bottom sheet that asks the passenger why they are cancelling. Designed to
/// match the reference in `opket-mini-app/public/screentshots/reason.jpg`.
///
/// Returned values:
///   - non-null `reasonKey` → user picked a reason and tapped Save.
///   - null with [confirmed] = true → user tapped X to skip (still cancels).
///   - null with [confirmed] = false → user dismissed without confirming.
class CancelReasonSheetResult {
  final bool confirmed;
  final String? reasonKey;
  const CancelReasonSheetResult({required this.confirmed, this.reasonKey});
}

Future<CancelReasonSheetResult?> showCancelReasonSheet(
  BuildContext context,
) async {
  return showModalBottomSheet<CancelReasonSheetResult>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _CancelReasonSheet(),
  );
}

class _CancelReasonSheet extends StatefulWidget {
  const _CancelReasonSheet();

  @override
  State<_CancelReasonSheet> createState() => _CancelReasonSheetState();
}

class _CancelReasonSheetState extends State<_CancelReasonSheet> {
  late Future<List<CancelReason>> _future;
  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    _future = CancelReasonsService.load();
  }

  void _save() {
    Navigator.of(
      context,
    ).pop(CancelReasonSheetResult(confirmed: true, reasonKey: _selectedKey));
  }

  void _skip() {
    Navigator.of(
      context,
    ).pop(const CancelReasonSheetResult(confirmed: true, reasonKey: null));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        // bottom: AppSpacing.lg,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Nima uchun buyurtmani bekor qilmoqchisiz?",
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<CancelReason>>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.grey,
                        strokeWidth: 1,
                      ),
                    ),
                  );
                }
                final reasons = snapshot.data ?? const <CancelReason>[];
                if (reasons.isEmpty) {
                  // Backend returned nothing — let the user still cancel.
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(
                      "Sabablar yuklanmadi.",
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final r in reasons)
                      _ReasonRow(
                        reason: r,
                        selected: r.key == _selectedKey,
                        onTap: () => setState(() => _selectedKey = r.key),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            AppIconButtonRectangle(
              text: "Saqlash",
              onPressed: _save,
              textColor: Colors.black,
              backgroundColor: const Color(0xFFFFE711),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReasonRow extends StatelessWidget {
  final CancelReason reason;
  final bool selected;
  final VoidCallback onTap;
  const _ReasonRow({
    required this.reason,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    reason.labelUz,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _RadioDot(selected: selected),
              ],
            ),
            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.grey.shade200),
          ],
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : Colors.grey.shade300,
          width: 2,
        ),
        color: selected ? AppColors.primary : Colors.transparent,
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.black)
          : null,
    );
  }
}
