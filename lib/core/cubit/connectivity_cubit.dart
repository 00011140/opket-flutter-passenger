import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/services/connectivity_service.dart';

class ConnectivityCubit extends Cubit<bool> {
  final ConnectivityService service;
  StreamSubscription? _sub;

  ConnectivityCubit(this.service) : super(true);

  void init() {
    _sub = service.connectionStream.listen((isConnected) {
      emit(isConnected);
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
