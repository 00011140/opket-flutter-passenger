import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';

class ClearBasketConfirmationDialog extends StatelessWidget {
  const ClearBasketConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: AppSpacing.md_lg),
      child: AppCard(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Qo'shilgan mahsulotlar o'chirilsinmi ?",
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: AppIconButtonRectangle(
                    text: "YO'Q",
                    onPressed: () {
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
                      context.read<CartCubit>().clear();
                      Navigator.pop(context);
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
      ),
    );
  }
}
