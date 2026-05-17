import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/feat/profile/services/referral_code_service.dart';

part 'referral_code_state.dart';

class ReferralCodeCubit extends Cubit<ReferralCodeState> {
  ReferralCodeCubit() : super(ReferralCodeInitial());

  Future<void> load() async {
    if (state is ReferralCodeLoading) return;
    emit(ReferralCodeLoading());
    try {
      final code = await ReferralCodeService().getMyReferralCode();
      if (code != null && code.isNotEmpty) {
        emit(ReferralCodeLoaded(code));
      } else {
        emit(ReferralCodeUnavailable());
      }
    } catch (_) {
      emit(ReferralCodeUnavailable());
    }
  }
}
