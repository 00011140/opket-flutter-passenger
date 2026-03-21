import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/myorders/cubit/active_orders_cubit.dart';
import 'package:opket/feat/myorders/cubit/get_active_orders_cubit.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:opket/feat/myorders/widgets/active_order_card.dart';
import 'package:opket/services/fcm_service.dart';

class ActiveOrders extends StatefulWidget {
  const ActiveOrders({super.key});

  @override
  State<ActiveOrders> createState() => _ActiveOrdersState();
}

class _ActiveOrdersState extends State<ActiveOrders> {
  StreamSubscription? _fcmSub;

  @override
  void initState() {
    super.initState();
    context.read<GetActiveOrdersCubit>().getActiveOrders();

    _fcmSub = FcmEvents.stream.listen((message) {
      context.read<GetActiveOrdersCubit>().getActiveOrders();

      // optionally filter by message type
      // if (message.data['type'] == 'order_update') {
      //   context.read<ActiveOrdersCubit>().loadOrders();
      // }
    });
  }

  @override
  void dispose() {
    _fcmSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 253, 253, 253),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Buyurtmalarim"),
        scrolledUnderElevation: 0,
      ),
      body: BlocBuilder<GetActiveOrdersCubit, GetActiveOrdersState>(
        builder: (context, state) {
          if (state is GetActiveOrdersSuccess) {
            final orders = state.orders;

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ActiveOrderCard(order: order);
              },
            );
          }

          return SizedBox.shrink();
        },
      ),
    );
  }
}
