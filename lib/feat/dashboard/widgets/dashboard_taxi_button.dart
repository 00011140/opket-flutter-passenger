import 'package:flutter/material.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/app/router/route_names.dart';

class TaxiButton extends StatelessWidget {
  const TaxiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppCard(
        borderRadius: 18,
        boxShadow: false,
        padding: EdgeInsets.all(0),
        child: Material(
          color: Colors.grey.shade100,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteNames.taxi);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/taxi_button_image.png", width: 80),
                  SizedBox(width: AppSpacing.sm_md),
                  Text(
                    "Taxi",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'WorkSans',
                      // fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
