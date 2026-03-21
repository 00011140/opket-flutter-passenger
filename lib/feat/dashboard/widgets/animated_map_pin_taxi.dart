import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/constants/app_icons.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/cubit/ride_cubit.dart';
import 'package:opket/feat/dashboard/controllers/map_pin_controller.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';

class AnimatedMapPinTaxi extends StatefulWidget {
  const AnimatedMapPinTaxi({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.isUserLocation,
  });

  final MapPinController controller;
  final bool isLoading;
  final bool isUserLocation;

  @override
  State<AnimatedMapPinTaxi> createState() => _AnimatedMapPinTaxiState();
}

class _AnimatedMapPinTaxiState extends State<AnimatedMapPinTaxi>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    /// Attach animation controls to controller
    widget.controller.attach(onLift: lift, onDrop: drop);
  }

  void lift() => _animationController.forward();
  void drop() => _animationController.reverse();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentRideCubit, CurrentRideState>(
      builder: (context, state) {
        return SizedBox(
          height: 85,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              BlocBuilder<RideCubit, RideState>(
                builder: (context, state) {
                  if (state is RideRequestSuccess) {
                    return Transform.translate(
                      offset: Offset(0, 40),
                      child: const RippleEffect(),
                    );
                  }

                  return SizedBox.shrink();
                },
              ),

              AnimatedBuilder(
                animation: _animation,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, _animation.value),
                  child: child,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pin head
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(53, 0, 0, 0),
                              blurRadius: 10,
                              spreadRadius: -5,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: widget.isUserLocation
                                    ? const Color(0xFFFFE711)
                                    : Colors.black,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                                  BlocBuilder<
                                    DeliveryFeeCubit,
                                    DeliveryFeeState
                                  >(
                                    builder: (context, state) {
                                      return Center(
                                        child: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: state is DeliveryFeeLoading
                                              ? const SizedBox(
                                                  key: ValueKey('loader'),
                                                  width: 24,
                                                  height: 24,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : TweenAnimationBuilder<Color?>(
                                                  tween: ColorTween(
                                                    begin: widget.isUserLocation
                                                        ? const Color.fromARGB(
                                                            255,
                                                            255,
                                                            91,
                                                            91,
                                                          )
                                                        : Colors.black,
                                                    end: widget.isUserLocation
                                                        ? Colors.black
                                                        : const Color.fromARGB(
                                                            255,
                                                            255,
                                                            91,
                                                            91,
                                                          ),
                                                  ),
                                                  duration: const Duration(
                                                    milliseconds: 250,
                                                  ),
                                                  builder:
                                                      (context, color, child) {
                                                        return Icon(
                                                          AppIcons.myLocation,
                                                          color: color,
                                                          size: 30,
                                                        );
                                                      },
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.sm,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0, 0.3),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  );
                                },
                                child: Text(
                                  widget.isUserLocation
                                      ? "Bu siz turgan \njoylashuv"
                                      : "Siz turgan \njoylashuv emas",
                                  key: ValueKey(
                                    widget.isUserLocation,
                                  ), // VERY IMPORTANT
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Pin stem
                      Container(
                        width: 3,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Shadow
              Positioned(
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
