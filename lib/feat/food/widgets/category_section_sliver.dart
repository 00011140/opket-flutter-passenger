import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/menu_items_cubit.dart';
import 'package:opket/feat/food/models/category_model.dart';
import 'package:opket/feat/food/widgets/menu_item_card.dart';
import 'package:shimmer/shimmer.dart';

// Each category has its own state entry.
typedef MenuItemsByCategoryState = Map<String, MenuItemsState>;

class CategoryHeaderSliver extends StatelessWidget {
  const CategoryHeaderSliver({
    super.key,
    required this.anchorKey,
    required this.title,
  });

  final GlobalKey anchorKey;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      key: anchorKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF111827),
          ),
        ),
      ),
    );
  }
}

class CategoryItemsSliver extends StatefulWidget {
  const CategoryItemsSliver({super.key, required this.params});

  final MenuItemsParams params;

  @override
  State<CategoryItemsSliver> createState() => _CategoryItemsSliverState();
}

class _CategoryItemsSliverState extends State<CategoryItemsSliver> {
  bool _requested = false;

  @override
  void initState() {
    context.read<MenuItemsCubit>().loadData(widget.params);

    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (!_requested) {
  //     _requested = true;
  //     context.read<MenuItemsCubit>().loadData(widget.params);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: This assumes MenuItemsCubit state is Map<String, MenuItemsState>
    return BlocBuilder<MenuItemsCubit, MenuItemsByCategoryState>(
      buildWhen: (prev, next) =>
          prev[widget.params.categoryId] != next[widget.params.categoryId],
      builder: (context, map) {
        final st = map[widget.params.categoryId] ?? MenuItemsInitial();

        if (st is MenuItemsLoading || st is MenuItemsInitial) {
          return const CategoryItemsShimmerSliver();
        }

        // if (st is MenuItemsError) {
        //   return SliverToBoxAdapter(
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //       child: Text(
        //         "Failed to load: ${st.message}",
        //         style: const TextStyle(color: Colors.red),
        //       ),
        //     ),
        //   );
        // }

        final items = (st as MenuItemsLoaded).data;
        if (items.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text("Menu bo'sh"),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) => ProductCard(product: items[index]),
              childCount: items.length,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.69,
            ),
          ),
        );
      },
    );
  }
}

class CategoryItemsShimmerSliver extends StatelessWidget {
  const CategoryItemsShimmerSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const _ProductShimmerCard(),
          childCount: 4,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.90,
        ),
      ),
    );
  }
}

class _ProductShimmerCard extends StatelessWidget {
  const _ProductShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

class CategoryHeaderShimmerSliver extends StatelessWidget {
  const CategoryHeaderShimmerSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.white,
          child: Container(
            height: 22,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

class CategorySectionSliver {
  static List<Widget> buildSlivers({
    required CategoryModel category,
    required MenuItemsParams params,
    required GlobalKey anchorKey,
  }) {
    return [
      CategoryHeaderSliver(anchorKey: anchorKey, title: category.name),
      CategoryItemsSliver(params: params),
    ];
  }
}
