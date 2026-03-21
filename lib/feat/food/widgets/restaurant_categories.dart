import 'package:flutter/material.dart';
import 'package:opket/feat/food/models/category_model.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantCategories extends StatelessWidget {
  const RestaurantCategories({
    super.key,
    required this.categories,
    required this.controller,
    required this.onTap,
    this.isLoading = false,
  });

  final List<CategoryModel> categories;
  final TabController? controller;
  final ValueChanged<int> onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const RestaurantCategoriesShimmer();

    if (controller == null || categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return _TabsBar(
      tabs: categories.map((e) => e.name).toList(),
      controller: controller!,
      onTap: onTap,
    );
  }
}

class _TabsBar extends StatelessWidget {
  final List<String> tabs;
  final TabController controller;
  final ValueChanged<int> onTap;

  const _TabsBar({
    required this.tabs,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        labelColor: const Color(0xFF111827),
        unselectedLabelColor: const Color(0xFF9CA3AF),
        indicatorColor: const Color(0xFF111827),
        indicatorWeight: 2,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        onTap: onTap,
        tabs: tabs.map((t) => Tab(text: t)).toList(),
      ),
    );
  }
}

class RestaurantCategoriesShimmer extends StatelessWidget {
  const RestaurantCategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: SizedBox(
        height: 15,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(width: 18),
          itemBuilder: (_, __) =>
              SizedBox(width: 130, child: _shimmerBox(height: 15, radius: 8)),
        ),
      ),
    );
  }

  static Widget _shimmerBox({
    double height = 16,
    double? width,
    double radius = 12,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 136, 134, 134),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
