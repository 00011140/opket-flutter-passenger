import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/widgets/app_container.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/food/cubit/cart_cubit.dart';
import 'package:opket/feat/food/cubit/cart_state.dart';
import 'package:opket/feat/food/cubit/menu_items_cubit.dart';
import 'package:opket/feat/food/cubit/restaurant_categories_cubit.dart';
import 'package:opket/feat/food/models/category_model.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/widgets/restaurant_categories.dart';
import 'package:opket/core/utils/extensions.dart';

import 'category_section_sliver.dart';

class RestaurantMenu extends StatefulWidget {
  const RestaurantMenu({super.key, required this.restaurant});
  final RestaurantModel restaurant;

  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final ScrollController _scrollController = ScrollController();

  List<CategoryModel> _categories = [];
  List<GlobalKey> _categoryKeys = [];

  @override
  void initState() {
    super.initState();
  }

  void _rebuildTabController(int length) {
    final old = _tabController;
    final oldIndex = old?.index ?? 0;
    final newIndex = length == 0 ? 0 : oldIndex.clamp(0, length - 1);

    old?.dispose();
    _tabController = TabController(
      length: length,
      vsync: this,
      initialIndex: newIndex,
    );
  }

  void _rebuildKeys(int length) {
    _categoryKeys = List.generate(length, (_) => GlobalKey());
  }

  Future<void> _scrollToCategory(int index) async {
    if (index < 0 || index >= _categoryKeys.length) return;
    final ctx = _categoryKeys[index].currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      alignment: 0, // 0 = top of viewport
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = context.read<CartCubit>().state.items;

    return Expanded(
      child: BlocConsumer<RestaurantCategoriesCubit, RestaurantCategoriesState>(
        listener: (context, state) {
          if (state is RestaurantCategoriesLoaded) {
            setState(() {
              _categories = state.data;
              _rebuildTabController(_categories.length);
              _rebuildKeys(_categories.length);
            });
          }
        },
        builder: (context, state) {
          if (state is RestaurantCategoriesLoading) {
            return const Center(child: RestaurantCategoriesShimmer());
          }

          if (_tabController == null || _categories.isEmpty) {
            return const SizedBox.shrink();
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ✅ pinned tabs
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabsHeaderDelegate(
                  height: 48,
                  child: RestaurantCategories(
                    categories: _categories,
                    controller: _tabController!,
                    onTap: (i) {
                      // When tab changes -> scroll to category section
                      _scrollToCategory(i);
                    },
                  ),
                ),
              ),

              if (widget.restaurant.delivery.freeOverAmount != null)
                SliverToBoxAdapter(
                  child: AppContainer(
                    top: true,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 236, 248, 231),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "Bepul yetkazish, ${widget.restaurant.delivery.freeOverAmount?.formatUzbekSoumFromCents()} so'm dan ortiq xarid uchun",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 29, 143, 29),
                        ),
                      ),
                    ),
                  ),
                ),

              for (int i = 0; i < _categories.length; i++) ...[
                ...CategorySectionSliver.buildSlivers(
                  category: _categories[i],
                  params: MenuItemsParams(
                    restaurantId: widget.restaurant.id,
                    categoryId: _categories[i].id,
                  ),
                  anchorKey: _categoryKeys[i],
                ),
              ],
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: state.items.isNotEmpty
                          ? MediaQuery.of(context).size.height * 0.16
                          : AppSpacing.lg,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TabsHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final Widget child;

  _TabsHeaderDelegate({required this.height, required this.child});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(color: Colors.white, child: child);
  }

  @override
  bool shouldRebuild(covariant _TabsHeaderDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
