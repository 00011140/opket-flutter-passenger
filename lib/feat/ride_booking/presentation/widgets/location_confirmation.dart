part of '../index.dart';

class LocationConfirmation extends StatefulWidget {
  final bool showLocationHints;
  final VoidCallback onPressNo;
  final VoidCallback onPressYes;

  const LocationConfirmation({
    super.key,
    required this.showLocationHints,
    required this.onPressNo,
    required this.onPressYes,
  });

  @override
  State<LocationConfirmation> createState() => _LocationConfirmationState();
}

class _LocationConfirmationState extends State<LocationConfirmation>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    context.read<LocationConfirmationCubit>().setData(
      shakeController: _shakeController,
    );

    // Shake immediately if it starts visible
    if (widget.showLocationHints) {
      _shakeController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant LocationConfirmation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger shake ONLY when false -> true
    if (!oldWidget.showLocationHints && widget.showLocationHints) {
      _shakeController
        ..reset()
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_on, size: 45, color: Colors.red),
            SizedBox(height: AppSpacing.sm),
            const Text(
              "Belgilangan manzil siz turgan joylashuv emas, TAXI shu yerga kelsinmi ?",
              style: TextStyle(
                // fontFamily: 'WorkSans',
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "YO'Q",
                    onPressed: () async {
                      widget.onPressNo();
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.grey.shade200,
                    textColor: Colors.black,
                    height: 55,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "HA",
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onPressYes();
                    },
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

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
}
