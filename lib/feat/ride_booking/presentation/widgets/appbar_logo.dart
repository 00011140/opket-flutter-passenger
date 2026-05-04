part of '../index.dart';

class AppbarLogo extends StatelessWidget {
  const AppbarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSpacing.md),
      padding: EdgeInsets.symmetric(
        vertical: AppSpacing.sm_md,
        horizontal: AppSpacing.sm_md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(200),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.black,
        highlightColor: Colors.white,
        child: AppContainer(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(AppIconsV2.app_logo, size: 30),
              const SizedBox(width: AppSpacing.sm_md),
              Text(
                "OPKET",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
