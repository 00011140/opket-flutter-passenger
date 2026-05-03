part of '../../index.dart';

class RideProgress {
  final int fare;
  final double distance;

  RideProgress({this.fare = 0, this.distance = 0});

  factory RideProgress.fromJson(Map<String, dynamic> json) {
    print(json);
    return RideProgress(
      fare: json['fare'].runtimeType == String
          ? int.parse(json['fare'])
          : json['fare'],
      distance: json['distance'].runtimeType == String
          ? double.parse(json['distance'])
          : json['distance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'fare': fare, 'distance': distance};
  }
}
