part of '../index.dart';

class FoodLogo extends StatelessWidget {
  const FoodLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, RouteNames.food);
        },
        child: SizedBox(
          height: double.infinity,
          child: AppContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/burger.png", width: 45),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  "TAOM",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
