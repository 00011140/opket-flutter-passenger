import 'package:flutter/material.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/app/router/route_names.dart';

class OrderFoodSuccessDialog extends StatelessWidget {
  const OrderFoodSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 45,
              color: Colors.green,
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              "Buyurtma yuborildi",
              style: TextStyle(
                fontFamily: 'WorkSans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            const Text(
              "Buyurtmangiz holati haqida sizga sms xabar berib turamiz",
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
              text: "OK",
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: const Color(0xFFFFE711),
              textColor: Colors.black,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
