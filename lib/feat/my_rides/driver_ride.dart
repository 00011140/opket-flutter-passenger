import 'dart:convert';

class DriverRide {
  final String id;
  final DateTime createdAt;
  final int fare;
  final double distanceTraveled;
  final String source; // "ride" or "ghostRide"
  final String? status;
  final String? rideType;

  DriverRide({
    required this.id,
    required this.createdAt,
    required this.fare,
    required this.distanceTraveled,
    required this.source,
    this.status,
    this.rideType,
  });

  factory DriverRide.fromJson(Map<String, dynamic> json) {
    return DriverRide(
      id: json['_id'].toString(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      fare: (json['fare'] ?? 0) is int
          ? (json['fare'] as int)
          : (json['fare'] as num).toInt(),
      distanceTraveled: (json['distanceTraveled'] ?? 0) is double
          ? (json['distanceTraveled'] as double)
          : (json['distanceTraveled'] as num).toDouble(),
      source: (json['source'] ?? 'ride') as String,
      status: json['status'] as String?,
      rideType: json['rideType'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "fare": fare,
        "distanceTraveled": distanceTraveled,
        "source": source,
        "status": status,
        "rideType": rideType,
      };
}

String ridesCacheKey({
  required String period,
  required String date, // YYYY-MM-DD
  required String tz,
}) =>
    "driver_rides:$period:$date:$tz";

String encodeRides(List<DriverRide> rides) =>
    jsonEncode(rides.map((r) => r.toJson()).toList());

List<DriverRide> decodeRides(String s) {
  final raw = (jsonDecode(s) as List).cast<Map<String, dynamic>>();
  return raw.map(DriverRide.fromJson).toList();
}
