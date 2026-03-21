part of 'restaurants_cubit.dart';

abstract class RestaurantsState {}

class RestaurantsInitial extends RestaurantsState {}

class RestaurantsLoading extends RestaurantsState {}

class RestaurantsLoaded extends RestaurantsState {
  final List<RestaurantModel> restaurants;
  final List<CuisineTypeModel> cuisines;
  final String query;

  RestaurantsLoaded({
    required this.restaurants,
    required this.cuisines,
    required this.query,
  });
}

class RestaurantsError extends RestaurantsState {
  final String message;
  RestaurantsError(this.message);
}
