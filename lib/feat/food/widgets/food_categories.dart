import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/food_categories_cubit.dart';
import 'package:opket/feat/food/cubit/restaurants_cubit.dart';
import 'package:opket/feat/food/models/food_category_model.dart';
import 'package:shimmer/shimmer.dart';

class FoodCategories extends StatefulWidget {
  final String? initialCategoryId;
  final void Function(FoodCategoryModel)? onCategoryTap;
  final double imageSize;
  final double separatorWidth;

  const FoodCategories({
    super.key,
    this.initialCategoryId,
    this.onCategoryTap,
    this.imageSize = 55,
    this.separatorWidth = 10,
  });

  @override
  State<FoodCategories> createState() => _FoodCategoriesState();
}

class _FoodCategoriesState extends State<FoodCategories> {
  List<FoodCategoryModel> categories = [];
  String? selectedId;

  @override
  void initState() {
    selectedId = widget.initialCategoryId;
    context.read<FoodCategoriesCubit>().loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodCategoriesCubit, FoodCategoriesState>(
      builder: (context, state) {
        print("FoodCategoriesCubit");
        print(state);
        if (state is FoodCategoriesLoading) {
          return FoodCategoriesShimmer();
        }
        if (state is FoodCategoriesLoaded) {
          return ListView.separated(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => SizedBox(width: widget.separatorWidth),
            itemBuilder: (context, i) => _CategoryBubble(
              item: categories[i],
              isSelected: selectedId == categories[i].id,
              imageSize: widget.imageSize,
              onTap: () {
                if (widget.onCategoryTap != null) {
                  widget.onCategoryTap!(categories[i]);
                  return;
                }
                setState(() {
                  if (selectedId == categories[i].id) {
                    selectedId = null;
                    context.read<RestaurantsCubit>().setQuery('');
                  } else {
                    selectedId = categories[i].id;
                    context.read<RestaurantsCubit>().setQuery(
                      categories[i].name,
                    );
                  }
                });
                FocusManager.instance.primaryFocus?.unfocus();
              },
            ),
          );
        }
        return SizedBox.shrink();
      },
      listener: (context, state) {
        if (state is FoodCategoriesError) {
          print("@@@@@@@@@@");

          print(state.message);
        } else if (state is FoodCategoriesLoaded) {
          setState(() {
            categories = state.data;
            if (widget.initialCategoryId != null && selectedId == null) {
              selectedId = widget.initialCategoryId;
            }
          });
        }
      },
    );
  }
}

class _CategoryBubble extends StatefulWidget {
  final FoodCategoryModel item;
  final bool isSelected;
  final VoidCallback onTap;
  final double imageSize;

  const _CategoryBubble({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.imageSize,
  });

  @override
  State<_CategoryBubble> createState() => _CategoryBubbleState();
}

class _CategoryBubbleState extends State<_CategoryBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
      reverseDuration: const Duration(milliseconds: 180),
    );

    _scale = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _bounceTap() async {
    // press down -> release (bounce back)
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isSelected
        ? Colors.orange.withOpacity(.15)
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      // clipBehavior: Clip.none,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: _bounceTap,
        onTapDown: (_) => _ctrl.forward(),
        onTapCancel: () => _ctrl.reverse(),
        child: SizedBox(
          width: widget.imageSize + 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  clipBehavior: Clip.none,
                  width: widget.imageSize,
                  height: widget.imageSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: bg,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.item.imageUrl,
                    fit: BoxFit.contain,
                    width: widget.imageSize,
                    height: widget.imageSize,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: widget.isSelected ? Colors.orange : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodCategoriesShimmer extends StatelessWidget {
  const FoodCategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (_, __) => SizedBox(
          width: 68,
          child: Column(
            children: [
              _shimmerBox(height: 54, width: 54, radius: 16),
              const SizedBox(height: 8),
              _shimmerBox(height: 10, width: 56, radius: 8),
            ],
          ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
