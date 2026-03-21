import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/myorders/cubit/get_order_status_cubit.dart';
import 'package:opket/feat/myorders/models/food_order.dart';
import 'package:shimmer/shimmer.dart';

class ActiveOrderLabel extends StatelessWidget {
  const ActiveOrderLabel({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return _label(status.color, status.label);
  }

  Widget _label(Color color, String label) {
    return Shimmer.fromColors(
      baseColor: color,
      highlightColor: color.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return "Yuborildi";
      case OrderStatus.preparing:
        return "Tayyorlanmoqda";
      case OrderStatus.readyForPickup:
        return "Yetkazilmoqda";
      case OrderStatus.delivered:
        return "Yetkazildi";
      case OrderStatus.cancelled:
        return "Bekor qilindi";
      default:
        return "Noma'lum";
    }
  }

  Color _statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.readyForPickup:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
