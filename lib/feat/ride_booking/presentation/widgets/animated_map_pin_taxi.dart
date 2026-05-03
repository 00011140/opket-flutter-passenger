import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons.dart';
import 'package:opket/core/constants/app_icons_v3.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/dashboard/controllers/map_pin_controller.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/feat/ride_booking/presentation/cubit/ride_map_cubit.dart';

class AnimatedMapPinTaxi extends StatefulWidget {
  const AnimatedMapPinTaxi({
    super.key,
    required this.controller,
    required this.isUserLocation,
  });

  final MapPinController controller;
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

    _animation = Tween<double>(begin: 0, end: -15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    /// Attach animation controls to controller
    widget.controller.attach(onLift: lift, onDrop: drop);
  }

  void lift() => _animationController.forward();
  void drop() => _animationController.reverse();

  @override
  void dispose() {
    widget.controller.detach(); // ✅ VERY IMPORTANT
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 85,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
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
                              BlocBuilder<DeliveryFeeCubit, DeliveryFeeState>(
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
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : TweenAnimationBuilder<Color?>(
                                              tween: ColorTween(
                                                begin: widget.isUserLocation
                                                    ? Colors.white
                                                    : Colors.black,
                                                end: widget.isUserLocation
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                              duration: const Duration(
                                                milliseconds: 250,
                                              ),
                                              builder: (context, color, child) {
                                                return Icon(
                                                  AppIconsV3.pickupIcon,
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
                        BlocBuilder<RideMapCubit, RideMapState>(
                          builder: (context, state) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              switchInCurve: Curves.easeOut,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    axis: Axis
                                        .horizontal, // collapses smoothly left/right
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.2, 0),
                                        end: Offset.zero,
                                      ).animate(animation),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: state.mapMoving
                                    ? const SizedBox()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.sm,
                                        ),
                                        child: Text(
                                          widget.isUserLocation
                                              ? "Bu siz turgan \njoylashuv"
                                              : "Siz turgan \njoylashuv emas",
                                        ),
                                      ),
                              ),
                            );
                          },
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
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              final blur = (_animation.value.abs() / 20) * 5;

              return Positioned(
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(400),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: blur,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
