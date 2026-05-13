class RideOption {
  final String id;
  final String optionId;
  final String title;
  final String? titleForPassenger;
  final String? description;
  final bool instant;
  final double charge;
  final int sortOrder;
  final bool showInPassengerApp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RideOption({
    required this.id,
    required this.optionId,
    required this.title,
    this.description,
    this.titleForPassenger,
    this.instant = false,
    required this.charge,
    this.sortOrder = 0,
    this.showInPassengerApp = true,
    this.createdAt,
    this.updatedAt,
  });

  factory RideOption.fromJson(Map<String, dynamic> json) {
    return RideOption(
      id: json['_id'] ?? json['id'],
      title: json['title'],
      optionId: json['option_id'],
      description: json['description'],
      titleForPassenger: json['title_for_passenger'],
      instant: json['instant'] ?? false,
      charge: (json['charge'] as num).toDouble(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      showInPassengerApp: json['show_in_passenger_app'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'option_id': optionId,
      'description': description,
      'title_for_passenger': titleForPassenger,
      'instant': instant,
      'charge': charge,
      'sort_order': sortOrder,
      'show_in_passenger_app': showInPassengerApp,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  RideOption copyWith({
    String? id,
    String? optionId,
    String? title,
    String? description,
    String? titleForPassenger,
    bool? instant,
    double? charge,
    int? sortOrder,
    bool? showInPassengerApp,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RideOption(
      id: id ?? this.id,
      optionId: optionId ?? this.optionId,
      title: title ?? this.title,
      titleForPassenger: titleForPassenger ?? this.titleForPassenger,
      description: description ?? this.description,
      instant: instant ?? this.instant,
      charge: charge ?? this.charge,
      sortOrder: sortOrder ?? this.sortOrder,
      showInPassengerApp: showInPassengerApp ?? this.showInPassengerApp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
