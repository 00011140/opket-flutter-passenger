import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/myorders/cubit/active_orders_cubit.dart';
import 'package:opket/feat/myorders/cubit/get_active_orders_cubit.dart'
    show GetActiveOrdersCubit, GetActiveOrdersState, GetActiveOrdersSuccess;
import 'package:opket/feat/myorders/cubit/get_order_status_cubit.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/widgets/active_order_card.dart';

class ActiveOrdersCarousel extends StatefulWidget {
  const ActiveOrdersCarousel({super.key});

  @override
  State<ActiveOrdersCarousel> createState() => _ActiveOrdersCarouselState();
}

class _ActiveOrdersCarouselState extends State<ActiveOrdersCarousel> {
  late final PageController _controller;

  // Start at a large number to simulate infinite scroll
  final int _initialPage = 1000;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      viewportFraction: 1,
      initialPage: _initialPage,
    );

    context.read<GetActiveOrdersCubit>().getActiveOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetActiveOrdersCubit, GetActiveOrdersState>(
      builder: (context, state) {
        if (state is GetActiveOrdersSuccess) {
          final orders = state.orders;

          if (orders.isEmpty) return SizedBox.shrink();

          return SizedBox(
            height: 140, // adjust based on your card height
            child: PageView.builder(
              clipBehavior: Clip.none,
              controller: _controller,
              itemBuilder: (context, index) {
                final order = orders[index % orders.length];

                return BlocProvider(
                  create: (_) => GetOrderStatusCubit(),

                  child: ActiveOrderCard(
                    order: order,
                    isSummary: true, // 👈 important
                  ),
                );
              },
            ),
          );
        }

        return SizedBox.shrink();
      },
    );
  }
}
