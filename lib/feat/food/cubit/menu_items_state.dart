part of 'menu_items_cubit.dart';

sealed class MenuItemsState {
  const MenuItemsState();
}

class MenuItemsInitial extends MenuItemsState {
  const MenuItemsInitial();
}

class MenuItemsLoading extends MenuItemsState {
  const MenuItemsLoading();
}

class MenuItemsLoaded extends MenuItemsState {
  final List<MenuItemModel> data;
  const MenuItemsLoaded(this.data);
}

class MenuItemsError extends MenuItemsState {
  final String message;
  const MenuItemsError(this.message);
}
