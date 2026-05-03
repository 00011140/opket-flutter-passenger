class DriverModel {
  final String name;
  final String phone;
  final String carModel;
  final String carColor;
  final String carNumber;
  final String regionCode;
  final String? eta;

  const DriverModel({
    required this.name,
    required this.phone,
    required this.carModel,
    required this.carColor,
    required this.carNumber,
    required this.regionCode,
    this.eta,
  });

  /// Convert DriverModel to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'carModel': carModel,
      'carColor': carColor,
      'carNumber': carNumber,
      'regionCode': regionCode,
      'eta': eta,
    };
  }

  /// Create DriverModel from Map
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      carModel: map['carModel'] ?? '',
      carColor: map['carColor'] ?? '',
      carNumber: map['carNumber'] ?? '',
      regionCode: map['regionCode'] ?? '',
      eta: map['eta'],
    );
  }
}
