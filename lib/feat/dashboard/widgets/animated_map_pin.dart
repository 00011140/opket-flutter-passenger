import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/dashboard/controllers/map_pin_controller.dart';
import 'package:opket/feat/food/cubit/delivery_fee_cubit.dart';
import 'package:opket/core/utils/extensions.dart';

class AnimatedMapPin extends StatefulWidget {
  const AnimatedMapPin({
    super.key,
    required this.controller,
    required this.isLoading,
  });

  final MapPinController controller;
  final bool isLoading;

  @override
  State<AnimatedMapPin> createState() => _AnimatedMapPinState();
}

class _AnimatedMapPinState extends State<AnimatedMapPin>
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
            child: MapPinWidget(),
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
  }
}

class MapPinWidget extends StatelessWidget {
  const MapPinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE711),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: BlocBuilder<DeliveryFeeCubit, DeliveryFeeState>(
                    builder: (context, state) {
                      return Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: state is DeliveryFeeLoading
                              ? const SizedBox(
                                  key: ValueKey('loader'),
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  AppIcons.deliveryMan,
                                  key: ValueKey('icon'),
                                  size: 35,
                                ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Container(
                  padding: EdgeInsets.only(right: AppSpacing.sm_md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yetkazish",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      BlocBuilder<DeliveryFeeCubit, DeliveryFeeState>(
                        builder: (context, state) {
                          int fee = 0;

                          if (state is DeliveryFeeLoaded) {
                            fee = state.data;
                          }

                          return Text(
                            "${fee.formatWithThousands()} so'm",
                            style: TextStyle(fontSize: 16),
                          );
                        },
                      ),
                    ],
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
    );
  }
}
