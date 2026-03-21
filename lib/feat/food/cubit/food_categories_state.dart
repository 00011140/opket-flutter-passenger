part of 'food_categories_cubit.dart';

abstract class FoodCategoriesState {}

class FoodCategoriesInitial extends FoodCategoriesState {}

class FoodCategoriesLoading extends FoodCategoriesState {}

class FoodCategoriesLoaded extends FoodCategoriesState {
  final List<FoodCategoryModel> data;
  FoodCategoriesLoaded(this.data);
}

class FoodCategoriesError extends FoodCategoriesState {
  final String message;
  FoodCategoriesError(this.message);
}
