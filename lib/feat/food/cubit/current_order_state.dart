import 'package:equatable/equatable.dart';
import 'package:opket/core/models/driver_location.dart';
import 'package:opket/core/models/driver_model.dart';

enum OrderStatus {
  idle,
  placed,
  accepted,
  preparing,
  readyForPickUp,
  pickedUp,
  onTheWay,
  delivered,
}

class CurrentOrderState extends Equatable {
  final String? orderId;
  final OrderStatus status;
  final DriverModel? driver;

  const CurrentOrderState({
    this.orderId,
    this.status = OrderStatus.idle,
    this.driver,
  });

  CurrentOrderState copyWith({
    String? orderId,
    OrderStatus? status,
    DriverModel? driver,
  }) {
    return CurrentOrderState(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      driver: driver ?? this.driver,
    );
  }

  /// Serialize to Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'status': status.name, // enum -> String
      'driver': driver?.toMap(), // nullable
    };
  }

  /// Deserialize from Map
  factory CurrentOrderState.fromMap(Map<String, dynamic> map) {
    return CurrentOrderState(
      orderId: map['orderId'] as String?,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => OrderStatus.placed,
      ),
      driver: map['driver'] != null ? DriverModel.fromMap(map['driver']) : null,
    );
  }

  @override
  List<Object?> get props => [orderId, status, driver];
}
