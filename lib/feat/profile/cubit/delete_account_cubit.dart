import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/services/general_api_service.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  void deleteAccount() async {
    emit(DeleteAccountLoading());
    try {
      await GeneralApiService().deleteAccount();
      emit(DeleteAccountSuccess());
    } catch (e) {
      emit(DeleteAccountError(message: e.toString()));
    }
  }
}
