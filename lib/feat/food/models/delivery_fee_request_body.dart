class DeliveryFeeRequestBody {
  final Location origin;
  final Location destination;
  final int? freeOverAmount;
  final int subtotal;

  DeliveryFeeRequestBody({
    required this.origin,
    required this.destination,
    this.freeOverAmount,
    required this.subtotal,
  });

  factory DeliveryFeeRequestBody.fromJson(Map<String, dynamic> json) {
    return DeliveryFeeRequestBody(
      origin: Location.fromJson(json['origin']),
      destination: Location.fromJson(json['destination']),
      subtotal: json['subtotal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'origin': origin.toJson(),
      'destination': destination.toJson(),
      'freeOverAmount': freeOverAmount,
      'subtotal': subtotal,
    };
  }
}

class Location {
  final double lat;
  final double lng;

  Location({required this.lat, required this.lng});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'lat': lat, 'lng': lng};
  }
}
