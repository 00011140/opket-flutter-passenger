import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/services/socket_service.dart';

part 'luggage_state.dart';

class LuggageCubit extends Cubit<LuggageState> {
  final socket = SocketService.instance;
  late final StreamSubscription _sub;

  LuggageCubit() : super(LuggageInitial()) {
    _sub = SocketService.instance.onAddLuggage.listen(_handleAddLuggageRequest);
  }

  void _handleAddLuggageRequest(data) {
    final luggageCharge = data['luggageCharge'];
    final driverId = data['driverId'];
    emit(
      DriverRequestingLuggage(luggageCharge: luggageCharge, driverId: driverId),
    );
  }

  void confirmLuggage(String driverId) {
    socket.confirmLuggage(driverId);
  }

  void declineLuggage(String driverId) {
    socket.declineLuggage(driverId);
  }

  void reset() {
    emit(LuggageInitial());
  }

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
