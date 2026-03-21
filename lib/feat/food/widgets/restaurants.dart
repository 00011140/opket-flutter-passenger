import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/food/cubit/restaurants_cubit.dart';
import 'package:opket/feat/food/widgets/coming_soon_food.dart';

import 'restaurant_card.dart';
import 'restaurants_by_cuisine_sliver.dart';

class RestaurantsSliver extends StatefulWidget {
  const RestaurantsSliver({super.key});

  @override
  State<RestaurantsSliver> createState() => _RestaurantsSliverState();
}

class _RestaurantsSliverState extends State<RestaurantsSliver> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantsCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsState>(
      builder: (context, state) {
        if (state is RestaurantsError) {
          print(state.message);
        }

        if (state is RestaurantsLoading) {
          return const SliverToBoxAdapter(child: RestaurantsShimmer());
        }

        if (state is RestaurantsLoaded) {
          final restaurants = state.restaurants;
          final cuisines = state.cuisines;
          final query = state.query;

          print(cuisines);

          if (restaurants.isEmpty) {
            // If searching, better empty message
            if (query.isNotEmpty) {
              return const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("Bunday restoran topilmadi"),
                ),
              );
            }
            return const SliverFillRemaining(child: ComingSoonFood());
          }

          // ✅ When searching: show normal vertical list
          if (query.isNotEmpty) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: restaurants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) =>
                    RestaurantCard(item: restaurants[i]),
              ),
            );
          }

          // ✅ No search: grouped by cuisine (vertical sections + horizontal lists)
          return RestaurantsByCuisineSliver(
            cuisines: cuisines,
            restaurants: restaurants,
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
