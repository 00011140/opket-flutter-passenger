part of 'restaurant_categories_cubit.dart';

abstract class RestaurantCategoriesState {}

class RestaurantCategoriesInitial extends RestaurantCategoriesState {}

class RestaurantCategoriesLoading extends RestaurantCategoriesState {}

class RestaurantCategoriesLoaded extends RestaurantCategoriesState {
  final List<CategoryModel> data;
  RestaurantCategoriesLoaded(this.data);
}

class RestaurantCategoriesError extends RestaurantCategoriesState {
  final String message;
  RestaurantCategoriesError(this.message);
}
