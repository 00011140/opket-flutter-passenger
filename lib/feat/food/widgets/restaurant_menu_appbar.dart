import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:opket/core/widgets/custom_back_button.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/widgets/clear_basket_confirmation_dialog.dart';

class RestaurantMenuAppbar extends StatelessWidget {
  const RestaurantMenuAppbar({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
      color: Colors.white,
      child: Row(
        children: [
          CustomBackButton(
            onPressed: !context.read<CartCubit>().state.isEmpty
                ? () {
                    showDialog<bool>(
                      context: context,
                      builder: (context) {
                        return ClearBasketConfirmationDialog();
                      },
                    );
                  }
                : null,
          ),
          Expanded(
            child: Center(
              child: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
            ),
          ),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.favorite_border), onPressed: () {}),
        ],
      ),
    );
  }
}
