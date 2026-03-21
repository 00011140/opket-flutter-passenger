import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/feat/ride/services/spam_guard_repository.dart';

import 'spam_guard_state.dart';

class SpamGuardCubit extends Cubit<SpamGuardState> {
  final CurrentRideCubit currentRideCubit;
  final SpamGuardRepository repo;

  SpamGuardCubit({required this.repo, required this.currentRideCubit})
    : super(SpamGuardState.initial());

  Timer? _timer;

  Future<void> init() async {
    await _refresh();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
  }

  Future<void> onUserCancelledRide() async {
    final rideStatus = currentRideCubit.state.status;
    if (rideStatus != RideStatus.accepted) return;

    await repo.recordCancel();
    await _refresh();
  }

  Future<void> _refresh() async {
    await repo.clearCooldownIfExpired();

    final endMs = await repo.getCooldownEndMs();
    if (endMs == null) {
      if (!isClosed) {
        emit(state.copyWith(blocked: false, timeLeft: Duration.zero));
      }
      return;
    }

    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final diff = endMs - nowMs;

    if (diff <= 0) {
      // expired; repo will clear next cycle too
      if (!isClosed) {
        emit(state.copyWith(blocked: false, timeLeft: Duration.zero));
      }
    } else {
      if (!isClosed) {
        emit(
          state.copyWith(blocked: true, timeLeft: Duration(milliseconds: diff)),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
