import 'package:flutter/material.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/feat/profile/custom_card.dart';

class SingleSettingContainer extends StatelessWidget {
  const SingleSettingContainer({
    super.key,
    required this.icondata,
    required this.title,
    this.rightContent,
    this.onTap,
    this.titleColor,
    this.iconColor,
  });

  final IconData icondata;
  final String title;
  final Color? titleColor;
  final Color? iconColor;
  final Widget? rightContent;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      borderRadius: 0,
      onTap: onTap,
      bgColor: Colors.white,
      shadow: false,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Center(child: Icon(icondata, size: 28, color: iconColor)),
              SizedBox(width: AppSpacing.md),
              Text(title, style: TextStyle(fontSize: 18, color: titleColor)),
            ],
          ),
          rightContent ?? Container(),
        ],
      ),
    );
  }
}
