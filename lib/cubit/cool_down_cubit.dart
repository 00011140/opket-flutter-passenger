import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/ride/cubit/current_ride_cubit.dart';
import 'package:opket/feat/ride/cubit/current_ride_state.dart';
import 'package:opket/services/cooldown_service.dart';

part 'cool_down_state.dart';

class CoolDownCubit extends Cubit<CoolDownState> {
  final CurrentRideCubit currentRideCubit;
  final CooldownStorageService _cooldownService = CooldownStorageService();

  CoolDownCubit(this.currentRideCubit) : super(CoolDownInActive());

  void active() {
    emit(CoolDownActive());
  }

  void inactive() {
    final accepted = currentRideCubit.state.status == RideStatus.accepted;
    if (!accepted) currentRideCubit.reset();
    emit(CoolDownInActive());
    _cooldownService.clearCooldown();
  }
}
