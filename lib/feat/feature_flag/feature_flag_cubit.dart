import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/services/socket_service.dart';

part 'feature_flag_state.dart';

class FeatureFlagCubit extends Cubit<FeatureFlagState> {
  final socket = SocketService.instance;
  late final StreamSubscription _featureFlagSub;

  FeatureFlagCubit() : super(const FeatureFlagState()) {
    _featureFlagSub = socket.onFeatureFlags.listen(_handleFeatureFlags);
  }

  /// -----------------------------
  /// Socket handlers
  /// -----------------------------

  void _handleFeatureFlags(dynamic data) {
    print("_handleFeatureFlags");
    print(data);
    final featureFlags = FeatureFlagState.fromMap(data);

    final newState = state.copyWith(
      isLuggageEnabled: featureFlags.isLuggageEnabled,
    );
    emit(newState);
  }

  @override
  Future<void> close() {
    _featureFlagSub.cancel();
    return super.close();
  }
}
