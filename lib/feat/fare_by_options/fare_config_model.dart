import 'dart:convert';

class FareServiceModel {
  final String id;
  final String description;
  final int charge;

  FareServiceModel({
    required this.id,
    required this.description,
    required this.charge,
  });

  factory FareServiceModel.fromJson(Map<String, dynamic> json) {
    return FareServiceModel(
      id: json["id"],
      description: json["description"],
      charge: (json["charge"] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "description": description,
    "charge": charge,
  };
}

class FareConfigModel {
  final int baseFare;
  final int perKm;
  final int firstKm;
  final int outsidePerKm;
  final int outsideFirstKm;
  final int perMinute;
  final bool luggageEnabled;
  final int luggageCharge;
  final List<FareServiceModel> services;
  final List<String> enabledServices;

  FareConfigModel({
    required this.baseFare,
    required this.perKm,
    required this.firstKm,
    required this.outsidePerKm,
    required this.outsideFirstKm,
    required this.perMinute,
    required this.luggageEnabled,
    required this.luggageCharge,
    required this.services,
    required this.enabledServices,
  });

  factory FareConfigModel.fromJson(Map<String, dynamic> json) {
    return FareConfigModel(
      baseFare: (json["baseFare"] as num).toInt(),
      perKm: (json["perKm"] as num).toInt(),
      firstKm: (json["firstKm"] as num).toInt(),
      outsidePerKm: (json["outsidePerKm"] as num).toInt(),
      outsideFirstKm: (json["outsideFirstKm"] as num).toInt(),
      perMinute: (json["perMinute"] as num).toInt(),
      luggageEnabled: json["luggageEnabled"] ?? false,
      luggageCharge: (json["luggageCharge"] as num).toInt(),
      services: (json["services"] as List<dynamic>? ?? [])
          .map((e) => FareServiceModel.fromJson(e))
          .toList(),
      enabledServices: [],
    );
  }

  Map<String, dynamic> toJson() => {
    "baseFare": baseFare,
    "perKm": perKm,
    "firstKm": firstKm,
    "outsidePerKm": outsidePerKm,
    "outsideFirstKm": outsideFirstKm,
    "perMinute": perMinute,
    "luggageEnabled": luggageEnabled,
    "luggageCharge": luggageCharge,
    "services": services.map((e) => e.toJson()).toList(),
    "enabledServices": enabledServices,
  };

  FareConfigModel copyWith({List<String>? enabledServices}) {
    return FareConfigModel(
      baseFare: baseFare,
      perKm: perKm,
      firstKm: firstKm,
      outsidePerKm: outsidePerKm,
      outsideFirstKm: outsideFirstKm,
      perMinute: perMinute,
      luggageEnabled: luggageEnabled,
      luggageCharge: luggageCharge,
      services: services,
      enabledServices: enabledServices ?? this.enabledServices,
    );
  }

  String toRawJson() => jsonEncode(toJson());
  static FareConfigModel fromRawJson(String raw) =>
      FareConfigModel.fromJson(jsonDecode(raw));
}

class FareConfigResponseModel {
  final FareConfigModel fare;
  final FareConfigModel farePremium;

  FareConfigResponseModel({required this.fare, required this.farePremium});

  factory FareConfigResponseModel.fromJson(Map<String, dynamic> json) {
    return FareConfigResponseModel(
      fare: FareConfigModel.fromJson(json["fare"]),
      farePremium: FareConfigModel.fromJson(json["farePremium"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "fare": fare.toJson(),
    "farePremium": farePremium.toJson(),
  };

  String toRawJson() => jsonEncode(toJson());
  static FareConfigResponseModel fromRawJson(String raw) =>
      FareConfigResponseModel.fromJson(jsonDecode(raw));
}
