part of '../../index.dart';

class SelectedRideOptionsCubit extends Cubit<List<String>> {
  SelectedRideOptionsCubit() : super([]);

  void toggleOption(String id) {
    if (state.contains(id)) {
      emit(state.where((e) => e != id).toList());
    } else {
      emit([...state, id]);
    }
  }

  void reset() {
    emit([]);
  }
}
