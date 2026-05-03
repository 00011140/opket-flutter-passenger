import 'package:flutter/material.dart';
import 'package:opket/core/theme/spacing.dart';

class ComingSoonFood extends StatelessWidget {
  const ComingSoonFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Tez kunda",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Uychi tumanidagi oshxona va fast food lar bilan kelishuvlar olib borilmoqda. Tez kunda ijtimoiy tarmoqlarda xabar beramiz",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'WorkSans',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
