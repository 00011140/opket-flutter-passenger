import 'package:flutter/material.dart';
import 'package:opket/components/app_card.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/core/spacing.dart';

class CancelRideConfirmation extends StatelessWidget {
  const CancelRideConfirmation({super.key, required this.onConfirmed});
  final VoidCallback onConfirmed;

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
                const Icon(Icons.close_rounded, size: 45, color: Colors.red),
                const Text(
                  "Buyurtmani haqiqatdan bekor qilasizmi ?",
                  style: TextStyle(
                    fontFamily: 'WorkSans',
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: AppIconButtonRectangle(
                        text: "YO'Q",
                        backgroundColor: Colors.grey.shade200,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        // onPressed: _requestNotificationPermission,
                        height: 55,
                      ),
                    ),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppIconButtonRectangle(
                        text: "HA",
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirmed();
                        },
                        // onPressed: _requestNotificationPermission,
                        backgroundColor: const Color(0xFFFFE711),
                        textColor: Colors.black,
                        height: 55,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
