import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/fare_by_options/fare_api_service.dart';
import 'package:opket/feat/fare_by_options/fare_cache_service.dart';
import 'fare_config_model.dart';
import 'fare_repository.dart';

class FareState extends Equatable {
  final bool loading;
  final String? error;
  final FareConfigResponseModel? data;
  final bool isPremiumSelected;

  const FareState({
    required this.loading,
    this.error,
    this.data,
    required this.isPremiumSelected,
  });

  FareConfigModel? get selectedFare => data == null
      ? null
      : (isPremiumSelected ? data!.farePremium : data!.fare);

  FareState copyWith({
    bool? loading,
    String? error,
    FareConfigResponseModel? data,
    bool? isPremiumSelected,
  }) {
    return FareState(
      loading: loading ?? this.loading,
      error: error,
      data: data ?? this.data,
      isPremiumSelected: isPremiumSelected ?? this.isPremiumSelected,
    );
  }

  @override
  List<Object?> get props => [loading, error, data, isPremiumSelected];
}

class FareCubit extends Cubit<FareState> {
  final FareRepository repo = FareRepository(
    api: FareApiService(),
    cache: FareCacheService(),
  );

  FareCubit()
    : super(const FareState(loading: false, isPremiumSelected: false));

  Future<void> loadFareConfig() async {
    emit(state.copyWith(loading: true, error: null));

    // 1) load cached first (fast UI)
    final cached = await repo.getCached();
    if (cached != null) {
      emit(state.copyWith(loading: false, data: cached, error: null));
    }

    // 2) refresh from API
    try {
      final fresh = await repo.fetchAndCache();
      emit(state.copyWith(loading: false, data: fresh, error: null));
    } catch (e) {
      // keep cached data if exists
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectPremium(bool premium) {
    emit(state.copyWith(isPremiumSelected: premium));
  }

  void toggleService(String serviceId) {
    if (state.data == null) return;

    final currentFare = state.selectedFare;
    if (currentFare == null) return;

    final enabled = List<String>.from(currentFare.enabledServices);

    if (enabled.contains(serviceId)) {
      enabled.remove(serviceId);
    } else {
      enabled.add(serviceId);
    }

    final updatedFare = currentFare.copyWith(enabledServices: enabled);

    final updatedResponse = FareConfigResponseModel(
      fare: updatedFare,
      farePremium: state.data!.farePremium,
    );

    emit(state.copyWith(data: updatedResponse));
  }

  void remove(String serviceId) {
    if (state.data == null) return;

    final currentFare = state.selectedFare;
    if (currentFare == null) return;

    final enabled = List<String>.from(currentFare.enabledServices);

    enabled.remove(serviceId);

    final updatedFare = currentFare.copyWith(enabledServices: enabled);

    final updatedResponse = FareConfigResponseModel(
      fare: updatedFare,
      farePremium: state.data!.farePremium,
    );

    emit(state.copyWith(data: updatedResponse));
  }

  void add(String serviceId) {
    if (state.data == null) return;

    final currentFare = state.selectedFare;
    if (currentFare == null) return;

    final enabled = List<String>.from(currentFare.enabledServices);

    enabled.add(serviceId);

    final updatedFare = currentFare.copyWith(enabledServices: enabled);

    final updatedResponse = FareConfigResponseModel(
      fare: updatedFare,
      farePremium: state.data!.farePremium,
    );

    emit(state.copyWith(data: updatedResponse));
  }
}
