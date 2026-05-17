import 'package:flutter/material.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/ride_options/domain/entities/ride_option.dart';

class RideCompletedSheet extends StatefulWidget {
  final int fare;
  final double distance;
  final String? driverName;
  final List<RideOption> selectedOptions;
  final Future<void> Function(int rating, String? comment) onSubmit;
  final VoidCallback onClose;

  const RideCompletedSheet({
    super.key,
    required this.fare,
    required this.distance,
    required this.driverName,
    required this.selectedOptions,
    required this.onSubmit,
    required this.onClose,
  });

  @override
  State<RideCompletedSheet> createState() => _RideCompletedSheetState();
}

class _RideCompletedSheetState extends State<RideCompletedSheet> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _formatFare(int fare) {
    final s = fare.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(s[i]);
    }
    return '${buffer.toString()} so\'m';
  }

  String _formatDistance(double distance) {
    if (distance >= 1) {
      return '${distance.toStringAsFixed(1)} km';
    }
    return '${(distance * 1000).toInt()} m';
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _submitting = true);
    await widget.onSubmit(
      _rating,
      _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
    );
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
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              'Safaringiz yakunlandi',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              "Quyida safar haqida ma'lumotlarni ko'rishingiz mumkin",
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.light.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _InfoRow(
            label: "Yo'l haqqi",
            value: _formatFare(widget.fare),
            icon: Icons.payments_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),
          _InfoRow(
            label: 'Yurilgan masofa',
            value: _formatDistance(widget.distance),
            icon: Icons.route_outlined,
          ),
          if (widget.selectedOptions.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            _OptionsRow(options: widget.selectedOptions),
          ],
          const SizedBox(height: AppSpacing.lg),
          Divider(color: AppColors.light.divider, height: 1),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Haydovchini baholang',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (widget.driverName != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.driverName!,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.light.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          _StarRating(
            value: _rating,
            onChanged: (v) => setState(() => _rating = v),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _commentController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: 'Izoh qoldiring (ixtiyoriy)',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: AppColors.light.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.light.onSurfaceBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _submitting ? null : widget.onClose,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: AppColors.light.outline),
                  ),
                  child: Text(
                    'O\'tkazib yuborish',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.light.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: ElevatedButton(
                  onPressed: (_rating == 0 || _submitting) ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: AppColors.gray30,
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Yuborish'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.light.onSurfaceBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: AppColors.light.textSecondary),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '$label:',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.light.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _OptionsRow extends StatelessWidget {
  final List<RideOption> options;

  const _OptionsRow({required this.options});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.light.onSurfaceBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.car_repair_outlined,
            size: 18,
            color: AppColors.light.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          "Avtomobil qo'shimchalari:",
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.light.textSecondary,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: options.map((o) {
              final label = o.titleForPassenger ?? o.title;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.light.surfaceSecondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _StarRating({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < value;
        return GestureDetector(
          onTap: () => onChanged(i + 1),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_outline_rounded,
              size: 40,
              color: filled ? const Color(0xFFFFB800) : AppColors.gray30,
            ),
          ),
        );
      }),
    );
  }
}
