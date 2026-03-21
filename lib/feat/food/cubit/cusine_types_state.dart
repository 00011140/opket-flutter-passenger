part of 'cusine_types_cubit.dart';

abstract class CusineTypesState {}

class CuisineTypesInitial extends CusineTypesState {}

class CuisineTypesLoading extends CusineTypesState {}

class CuisineTypesLoaded extends CusineTypesState {
  final List<CuisineTypeModel> data;
  CuisineTypesLoaded(this.data);
}

class CuisineTypesError extends CusineTypesState {
  final String message;
  CuisineTypesError(this.message);
}
