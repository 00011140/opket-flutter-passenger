part of '../index.dart';

class AppbarLogo extends StatelessWidget {
  const AppbarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm_md,
      ),
      child: AppContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(AppIconsV2.app_logo, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(
              "OPKET",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
