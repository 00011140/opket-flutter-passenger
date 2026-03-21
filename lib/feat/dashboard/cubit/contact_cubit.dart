import 'package:flutter_bloc/flutter_bloc.dart';

class ContactCubit extends Cubit<bool> {
  ContactCubit() : super(false);

  void setData(bool value) {
    emit(value);
  }
}
