part of '../index.dart';

class SearchingDriversPin extends StatelessWidget {
  const SearchingDriversPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Image.asset('assets/pickup_location_pin.png', width: 50),
        BlocBuilder<ActiveRideCubit, ActiveRideState>(
          builder: (context, state) {
            final status = state.status;

            if (status == RideStatus.searching) {
              return Transform.translate(
                offset: Offset(0, 40),
                child: const RippleEffect(),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class RippleEffect extends StatefulWidget {
  const RippleEffect({super.key});

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCircle(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final value = (_controller.value + delay) % 1;

        return Transform.scale(
          scale: value * 6, // expands outward
          child: Opacity(
            opacity: 1 - value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.5),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [_buildCircle(0.0), _buildCircle(0.3), _buildCircle(0.6)],
    );
  }
}
