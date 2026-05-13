import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_container.dart';
import 'package:opket/core/constants/app_icons.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/restaurants_cubit.dart';
import 'package:opket/feat/food/widgets/food_categories.dart';
import 'package:opket/feat/food/widgets/restaurants.dart';
import 'package:opket/feat/myorders/widgets/active_orders_carousel.dart';

class RestaurantsPage extends StatefulWidget {
  final String? initialCategoryId;
  final String? initialCategoryName;

  const RestaurantsPage({
    super.key,
    this.initialCategoryId,
    this.initialCategoryName,
  });

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialCategoryName != null) {
      context.read<RestaurantsCubit>().setQuery(widget.initialCategoryName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: IconButton.filled(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.black38,
          elevation: 4,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(AppIcons.chevronLeft),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            bottom: false,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // AppContainer(
                  //   top: true,
                  //   bottom: true,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Expanded(child: RestaurantsSearchBar()),
                  //       IconButton(
                  //         icon: const Icon(Icons.close),
                  //         onPressed: () {
                  //           Navigator.pop(context);
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: RestaurantsContent(
                      initialCategoryId: widget.initialCategoryId,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RestaurantsContent extends StatelessWidget {
  final String? initialCategoryId;

  const RestaurantsContent({super.key, this.initialCategoryId});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

      slivers: [
        const SliverToBoxAdapter(child: ActiveOrdersCarousel()),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

        const SliverToBoxAdapter(child: RestaurantsSearchBar()),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 80,
            child: Stack(
              children: [
                FoodCategories(initialCategoryId: initialCategoryId),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

        // ✅ Correct: sliver restaurants list
        const RestaurantsSliver(),

        // ✅ Ensure last card isn’t hidden by system navigation/gesture bar
        SliverToBoxAdapter(child: SizedBox(height: 18 + bottomInset)),
      ],
    );
  }
}

class RestaurantsSearchBar extends StatelessWidget {
  const RestaurantsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: TextField(
        textAlign: TextAlign.center,
        onChanged: (v) => context.read<RestaurantsCubit>().setQuery(v),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: null, // remove default hint
          hintStyle: const TextStyle(fontSize: 16),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: null,
          // 👇 custom centered layout
          hint: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                AppIcons.wallet,
                color: Color.fromARGB(255, 148, 148, 148),
                size: 30,
              ),
              SizedBox(width: 8),
              Text(
                "Oshxona yoki Taom nomi",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 148, 148, 148),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
