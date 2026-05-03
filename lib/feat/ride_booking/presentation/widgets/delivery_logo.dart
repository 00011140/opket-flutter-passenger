part of '../index.dart';

class DeliveryLogo extends StatelessWidget {
  const DeliveryLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: double.infinity,
          child: AppContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "YETKAZ",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                const Icon(AppIconsV3.deliveryIcon, size: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
