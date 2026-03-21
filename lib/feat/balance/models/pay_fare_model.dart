class PayFareModel {
  final String driverName;
  final int amount;
  final String driverId;

  PayFareModel({
    required this.driverName,
    required this.amount,
    required this.driverId,
  });

  Map<String, dynamic> toMap() {
    return {"driverName": driverName, "amount": amount, "driverId": driverId};
  }
}
