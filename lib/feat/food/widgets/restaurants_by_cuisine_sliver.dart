import 'package:flutter/material.dart';
import 'package:opket/feat/food/models/cuisine_type_model.dart';
import 'package:opket/feat/food/models/restaurant_model.dart';
import 'package:opket/feat/food/widgets/coming_soon_food.dart';

import 'restaurant_card.dart';

class RestaurantsByCuisineSliver extends StatelessWidget {
  final List<CuisineTypeModel> cuisines;
  final List<RestaurantModel> restaurants;

  const RestaurantsByCuisineSliver({
    super.key,
    required this.cuisines,
    required this.restaurants,
  });

  @override
  Widget build(BuildContext context) {
    final grouped = groupRestaurantsByCuisine(restaurants);

    final sortedCuisines = [...cuisines]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    // Only show cuisines that have restaurants (optional)
    final visibleCuisines = sortedCuisines
        .where((c) => (grouped[c.id]?.isNotEmpty ?? false))
        .toList(growable: false);

    if (visibleCuisines.isEmpty) {
      return const SliverToBoxAdapter(child: ComingSoonFood());
    }

    return SliverList.builder(
      itemCount: visibleCuisines.length,
      itemBuilder: (context, index) {
        final cuisine = visibleCuisines[index];
        final items = grouped[cuisine.id] ?? const <RestaurantModel>[];

        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: _CuisineSection(cuisine: cuisine, restaurants: items),
        );
      },
    );
  }

  Map<String, List<RestaurantModel>> groupRestaurantsByCuisine(
    List<RestaurantModel> restaurants,
  ) {
    final map = <String, List<RestaurantModel>>{};

    for (final r in restaurants) {
      map.putIfAbsent(r.cuisineTypeId, () => []).add(r);
    }

    // Sort each cuisine group by rating
    for (final list in map.values) {
      list.sort((a, b) => b.ratingAvg.compareTo(a.ratingAvg));
    }

    return map;
  }
}

class _CuisineSection extends StatelessWidget {
  final CuisineTypeModel cuisine;
  final List<RestaurantModel> restaurants;

  const _CuisineSection({required this.cuisine, required this.restaurants});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                cuisine.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        if (restaurants.length == 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: RestaurantCard(item: restaurants[0]),
          ),
        // Horizontal restaurants
        if (restaurants.length > 1)
          SizedBox(
            height: 220, // adjust to your RestaurantCard height
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: restaurants.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) {
                return SizedBox(
                  width: 300, // important: give width in horizontal list
                  child: RestaurantCard(item: restaurants[i]),
                );
              },
            ),
          ),
      ],
    );
  }
}
