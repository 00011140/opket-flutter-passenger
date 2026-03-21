import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/models/cart_item.dart';
import 'package:opket/utils/extensions.dart';

class BasketItems extends StatelessWidget {
  const BasketItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state.items.isEmpty) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final items = state.items;

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
          itemBuilder: (_, i) => _CartRow(
            cartItem: items[i],
            onMinus: () =>
                context.read<CartCubit>().decrement(items[i].item.id),
            onPlus: () => context.read<CartCubit>().increment(items[i].item.id),
          ),
        );
      },
    );
  }
}

class _CartRow extends StatelessWidget {
  final CartItem cartItem; // <-- domain CartItem (from cubit)
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _CartRow({
    required this.cartItem,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final m = cartItem.item; // MenuItemModel
    final qty = cartItem.quantity;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                m.name, // adjust field name if different
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    m.price
                        .formatUzbekSoumFromCents(), // adjust if your model uses different naming
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  // const SizedBox(width: 4),
                  // const Text(
                  //   " · ",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Color(0xFF9CA3AF),
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                  // Text(
                  //   "370 g", // adjust if needed
                  //   style: const TextStyle(
                  //     fontSize: 16,
                  //     color: Color(0xFF9CA3AF),
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        SizedBox(
          width: 140, // keep stepper stable
          child: _QtyStepper(qty: qty, onMinus: onMinus, onPlus: onPlus),
        ),
      ],
    );
  }
}

class _QtyStepper extends StatelessWidget {
  final int qty;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _QtyStepper({
    required this.qty,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _IconBtn(icon: Icons.remove, onTap: onMinus),
          Expanded(
            child: Center(
              child: Text(
                "$qty",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
          ),
          _IconBtn(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: SizedBox(
        width: 36,
        height: 36,
        child: Icon(icon, size: 22, color: const Color(0xFF111827)),
      ),
    );
  }
}
