part of '../index.dart';

class FoodLogo extends StatelessWidget {
  const FoodLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSpacing.md),

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.4,
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(200),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, RouteNames.food),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: SizedBox(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _AnimatedBurger(),
                    const SizedBox(width: AppSpacing.sm),
                    Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.white,
                      child: Text(
                        "TAOM",
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedBurger extends StatefulWidget {
  const _AnimatedBurger();

  @override
  State<_AnimatedBurger> createState() => _AnimatedBurgerState();
}

class _AnimatedBurgerState extends State<_AnimatedBurger>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _bounceController;

  late final Animation<double> _idleRotation;
  late final Animation<double> _spinRotation;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    // 🔄 Idle slow rotation
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _idleRotation = Tween(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    // 🍔 Bounce controller
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // 🔥 Scale (juicy bounce)
    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.2,
          end: 0.95,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.95,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
    ]).animate(_bounceController);

    // 🛞 Fast spin ONLY during bounce
    _spinRotation = Tween(begin: 0.0, end: 6.28).animate(
      // 1 full turn
      CurvedAnimation(parent: _bounceController, curve: Curves.easeOut),
    );

    _startAutoBounce();
  }

  void _startAutoBounce() async {
    while (mounted) {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        _bounceController.forward(from: 0);
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotationController, _bounceController]),
      builder: (_, child) {
        final isBouncing = _bounceController.isAnimating;

        final rotation = isBouncing
            ? _spinRotation
                  .value // fast spin
            : _idleRotation.value; // slow tilt

        return Transform.rotate(
          angle: rotation,
          child: Transform.scale(scale: _scale.value, child: child),
        );
      },
      child: Image.asset("assets/burger.png", width: 45),
    );
  }
}
