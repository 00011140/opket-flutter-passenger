class DeliveryFeeResponse {
  final double distanceKm;
  final double fee;
  final bool? fallbackUsed;

  DeliveryFeeResponse({
    required this.distanceKm,
    required this.fee,
    this.fallbackUsed,
  });

  factory DeliveryFeeResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryFeeResponse(
      distanceKm: (json['distanceKm'] as num).toDouble(),
      fee: (json['fee'] as num).toDouble(),
      fallbackUsed: json['fallbackUsed'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'distanceKm': distanceKm,
      'fee': fee,
      if (fallbackUsed != null) 'fallbackUsed': fallbackUsed,
    };
  }
}
