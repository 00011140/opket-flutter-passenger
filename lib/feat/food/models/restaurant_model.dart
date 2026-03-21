// restaurant_model.dart
// Refactored to match the new Mongo Restaurant schema.

enum RestaurantStatus { active, suspended, deleted }

enum FulfillmentMode { delivery, pickup }

enum PaymentMethod { cash, card, wallet }

enum PriceTier { one, two, three, four } // $..$$$$

RestaurantStatus restaurantStatusFromJson(String? v) {
  switch (v) {
    case 'ACTIVE':
      return RestaurantStatus.active;
    case 'SUSPENDED':
      return RestaurantStatus.suspended;
    case 'DELETED':
      return RestaurantStatus.deleted;
    default:
      return RestaurantStatus.active;
  }
}

String restaurantStatusToJson(RestaurantStatus v) {
  switch (v) {
    case RestaurantStatus.active:
      return 'ACTIVE';
    case RestaurantStatus.suspended:
      return 'SUSPENDED';
    case RestaurantStatus.deleted:
      return 'DELETED';
  }
}

FulfillmentMode? fulfillmentModeFromJson(String? v) {
  switch (v) {
    case 'DELIVERY':
      return FulfillmentMode.delivery;
    case 'PICKUP':
      return FulfillmentMode.pickup;
    default:
      return null;
  }
}

String fulfillmentModeToJson(FulfillmentMode v) {
  switch (v) {
    case FulfillmentMode.delivery:
      return 'DELIVERY';
    case FulfillmentMode.pickup:
      return 'PICKUP';
  }
}

PaymentMethod? paymentMethodFromJson(String? v) {
  switch (v) {
    case 'CASH':
      return PaymentMethod.cash;
    case 'CARD':
      return PaymentMethod.card;
    case 'WALLET':
      return PaymentMethod.wallet;
    default:
      return null;
  }
}

String paymentMethodToJson(PaymentMethod v) {
  switch (v) {
    case PaymentMethod.cash:
      return 'CASH';
    case PaymentMethod.card:
      return 'CARD';
    case PaymentMethod.wallet:
      return 'WALLET';
  }
}

PriceTier? priceTierFromJson(dynamic v) {
  if (v == null) return null;
  final n = (v as num).toInt();
  switch (n) {
    case 1:
      return PriceTier.one;
    case 2:
      return PriceTier.two;
    case 3:
      return PriceTier.three;
    case 4:
      return PriceTier.four;
    default:
      return null;
  }
}

int? priceTierToJson(PriceTier? v) {
  if (v == null) return null;
  switch (v) {
    case PriceTier.one:
      return 1;
    case PriceTier.two:
      return 2;
    case PriceTier.three:
      return 3;
    case PriceTier.four:
      return 4;
  }
}

/// GeoJSON Point: coordinates = [lng, lat]
class GeoPoint {
  final String type; // always "Point"
  final double lng;
  final double lat;

  const GeoPoint({this.type = 'Point', required this.lng, required this.lat});

  factory GeoPoint.fromJson(Map<String, dynamic> json) {
    final coords = (json['coordinates'] as List?) ?? const [];
    final lng = coords.length > 0 ? (coords[0] as num).toDouble() : 0.0;
    final lat = coords.length > 1 ? (coords[1] as num).toDouble() : 0.0;
    return GeoPoint(
      type: (json['type'] as String?) ?? 'Point',
      lng: lng,
      lat: lat,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type,
    'coordinates': [lng, lat],
  };
}

class RestaurantAddress {
  final String line1;
  final String? line2;
  final String city;
  final String region;
  final String? postalCode;
  final String? country;

  const RestaurantAddress({
    required this.line1,
    this.line2,
    required this.city,
    required this.region,
    this.postalCode,
    this.country,
  });

  factory RestaurantAddress.fromJson(Map<String, dynamic> json) {
    return RestaurantAddress(
      line1: (json['line1'] as String?) ?? '',
      line2: json['line2'] as String?,
      city: (json['city'] as String?) ?? '',
      region: (json['region'] as String?) ?? '',
      postalCode: json['postalCode'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'line1': line1,
    'line2': line2,
    'city': city,
    'region': region,
    'postalCode': postalCode,
    'country': country,
  };
}

class RestaurantDeliverySettings {
  final double radiusKm;
  final int feeBase;
  final double? feePerKm;
  final double? feeMin;
  final double? feeMax;
  final int? freeOverAmount;

  const RestaurantDeliverySettings({
    required this.radiusKm,
    required this.feeBase,
    this.feePerKm,
    this.feeMin,
    this.feeMax,
    required this.freeOverAmount,
  });

  factory RestaurantDeliverySettings.fromJson(Map<String, dynamic>? json) {
    json ??= const {};
    double? _d(dynamic v) => v == null ? null : (v as num).toDouble();
    int? _int(dynamic v) => v == null ? null : (v as num).toInt();

    return RestaurantDeliverySettings(
      radiusKm: _d(json['radius_km']) ?? _d(json['radiusKm']) ?? 8.0,
      feeBase: _int(json['fee_base']) ?? _int(json['feeBase']) ?? 0,
      feePerKm: _d(json['fee_per_km'] ?? json['feePerKm']),
      feeMin: _d(json['fee_min'] ?? json['feeMin']),
      feeMax: _d(json['fee_max'] ?? json['feeMax']),
      freeOverAmount: _int(json['free_over_amount'] ?? json['freeOverAmount']),
    );
  }

  Map<String, dynamic> toJson() => {
    'radius_km': radiusKm,
    'fee_base': feeBase,
    'fee_per_km': feePerKm,
    'fee_min': feeMin,
    'fee_max': feeMax,
    'free_over_amount': freeOverAmount,
  };
}

class RestaurantPayout {
  final bool enabled;
  final String? bankName;
  final String? accountLast4;
  final String? accountHolder;

  const RestaurantPayout({
    required this.enabled,
    this.bankName,
    this.accountLast4,
    this.accountHolder,
  });

  factory RestaurantPayout.fromJson(Map<String, dynamic>? json) {
    json ??= const {};
    return RestaurantPayout(
      enabled: (json['enabled'] as bool?) ?? false,
      bankName: json['bank_name'] as String? ?? json['bankName'] as String?,
      accountLast4:
          json['account_last4'] as String? ?? json['accountLast4'] as String?,
      accountHolder:
          json['account_holder'] as String? ?? json['accountHolder'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'enabled': enabled,
    'bank_name': bankName,
    'account_last4': accountLast4,
    'account_holder': accountHolder,
  };
}

class RestaurantMetrics {
  final int activeOrdersCount;
  final DateTime? lastOrderAt;
  final double? avgReadyTimeMin;

  const RestaurantMetrics({
    required this.activeOrdersCount,
    this.lastOrderAt,
    this.avgReadyTimeMin,
  });

  factory RestaurantMetrics.fromJson(Map<String, dynamic>? json) {
    json ??= const {};
    DateTime? _dt(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());
    double? _d(dynamic v) => v == null ? null : (v as num).toDouble();

    return RestaurantMetrics(
      activeOrdersCount:
          ((json['active_orders_count'] ?? json['activeOrdersCount']) as num?)
              ?.toInt() ??
          0,
      lastOrderAt: _dt(json['last_order_at'] ?? json['lastOrderAt']),
      avgReadyTimeMin: _d(
        json['avg_ready_time_min'] ?? json['avgReadyTimeMin'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'active_orders_count': activeOrdersCount,
    'last_order_at': lastOrderAt?.toIso8601String(),
    'avg_ready_time_min': avgReadyTimeMin,
  };
}

class RestaurantModel {
  // Ownership / identity
  final String id;
  final String ownerUserId;
  final String cuisineTypeId;
  final RestaurantStatus status;

  // Public profile
  final String name;
  final String? description;
  final String phone;

  // Address
  final RestaurantAddress address;

  // Location
  final GeoPoint? location;

  // Media
  final String? logoUrl;
  final String? logoPublicId;
  final String? bannerUrl;
  final String? bannerPublicId;
  final List<String> galleryUrls;

  // Marketplace attributes
  final List<String> cuisineTypes;
  final List<String> tags;
  final PriceTier? priceTier;

  // Availability / ordering
  final bool isOpen;
  final bool acceptingOrders;
  final String? temporarilyClosedReason;
  final dynamic hoursJson; // keep flexible
  final String? timezone;

  final List<FulfillmentMode> fulfillmentModes;
  final List<PaymentMethod> paymentMethods;
  final bool supportsScheduledOrders;
  final bool autoAcceptOrders;

  // Operational settings
  final int prepTimeMin;
  final int prepTimeMax;
  final double minOrderAmount;
  final RestaurantDeliverySettings delivery;

  // Financials / settlement
  final String currency;
  final double commissionPercent;
  final RestaurantPayout payout;

  // Reputation
  final double ratingAvg;
  final int ratingCount;

  // Performance
  final RestaurantMetrics metrics;

  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;

  const RestaurantModel({
    required this.id,
    required this.ownerUserId,
    required this.cuisineTypeId,
    required this.status,
    required this.name,
    this.description,
    required this.phone,
    required this.address,
    this.location,
    this.logoUrl,
    this.logoPublicId,
    this.bannerUrl,
    this.bannerPublicId,
    this.galleryUrls = const [],
    this.cuisineTypes = const [],
    this.tags = const [],
    this.priceTier,
    required this.isOpen,
    required this.acceptingOrders,
    this.temporarilyClosedReason,
    this.hoursJson,
    this.timezone,
    this.fulfillmentModes = const [FulfillmentMode.delivery],
    this.paymentMethods = const [PaymentMethod.cash],
    required this.supportsScheduledOrders,
    required this.autoAcceptOrders,
    required this.prepTimeMin,
    required this.prepTimeMax,
    required this.minOrderAmount,
    required this.delivery,
    required this.currency,
    required this.commissionPercent,
    required this.payout,
    required this.ratingAvg,
    required this.ratingCount,
    required this.metrics,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convenience (legacy compatibility)
  double? get lat => location?.lat;
  double? get lng => location?.lng;

  /// FROM JSON (MongoDB / API)
  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    DateTime _parseDt(dynamic v) => DateTime.parse(v.toString());
    double _double(dynamic v, {double fallback = 0}) =>
        v == null ? fallback : (v as num).toDouble();

    // Handle location + also allow legacy lat/lng if backend still sends them
    GeoPoint? location;
    if (json['location'] is Map<String, dynamic>) {
      location = GeoPoint.fromJson(json['location'] as Map<String, dynamic>);
    } else if (json['location'] is Map) {
      location = GeoPoint.fromJson(Map<String, dynamic>.from(json['location']));
    } else if (json['lat'] != null && json['lng'] != null) {
      location = GeoPoint(
        lng: (json['lng'] as num).toDouble(),
        lat: (json['lat'] as num).toDouble(),
      );
    }

    final fmRaw =
        (json['fulfillment_modes'] ?? json['fulfillmentModes']) as List?;
    final pmRaw = (json['payment_methods'] ?? json['paymentMethods']) as List?;

    final fulfillmentModes = (fmRaw ?? const [])
        .map((e) => fulfillmentModeFromJson(e?.toString()))
        .whereType<FulfillmentMode>()
        .toList();

    final paymentMethods = (pmRaw ?? const [])
        .map((e) => paymentMethodFromJson(e?.toString()))
        .whereType<PaymentMethod>()
        .toList();

    return RestaurantModel(
      id: (json['_id'] ?? json['id']).toString(),
      ownerUserId: (json['ownerUserId'] ?? json['owner_user_id']).toString(),
      cuisineTypeId: (json['cuisineTypeId'] ?? json['cuisineTypeId'])
          .toString(),
      status: restaurantStatusFromJson(json['status'] as String?),

      name: (json['name'] as String?) ?? '',
      description: json['description'] as String?,
      phone: (json['phone'] as String?) ?? '',

      address: RestaurantAddress.fromJson(
        Map<String, dynamic>.from((json['address'] as Map?) ?? const {}),
      ),

      location: location,

      logoUrl: json['logo_url'] as String? ?? json['logoUrl'] as String?,
      logoPublicId:
          json['logo_public_id'] as String? ?? json['logoPublicId'] as String?,
      bannerUrl: json['banner_url'] as String? ?? json['bannerUrl'] as String?,
      bannerPublicId:
          json['banner_public_id'] as String? ??
          json['bannerPublicId'] as String?,
      galleryUrls:
          ((json['gallery_urls'] ?? json['galleryUrls']) as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],

      cuisineTypes:
          ((json['cuisine_types'] ?? json['cuisineTypes']) as List?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      tags:
          ((json['tags']) as List?)?.map((e) => e.toString()).toList() ??
          const [],
      priceTier: priceTierFromJson(json['price_tier'] ?? json['priceTier']),

      isOpen: (json['is_open'] as bool?) ?? (json['isOpen'] as bool?) ?? true,
      acceptingOrders:
          (json['accepting_orders'] as bool?) ??
          (json['acceptingOrders'] as bool?) ??
          true,
      temporarilyClosedReason:
          json['temporarily_closed_reason'] as String? ??
          json['temporarilyClosedReason'] as String?,
      hoursJson: json['hours_json'] ?? json['hoursJson'],
      timezone: json['timezone'] as String?,

      fulfillmentModes: fulfillmentModes.isNotEmpty
          ? fulfillmentModes
          : const [FulfillmentMode.delivery],
      paymentMethods: paymentMethods.isNotEmpty
          ? paymentMethods
          : const [PaymentMethod.cash],
      supportsScheduledOrders:
          (json['supports_scheduled_orders'] as bool?) ??
          (json['supportsScheduledOrders'] as bool?) ??
          false,
      autoAcceptOrders:
          (json['auto_accept_orders'] as bool?) ??
          (json['autoAcceptOrders'] as bool?) ??
          false,

      prepTimeMin:
          ((json['prep_time_min'] ?? json['prepTimeMin']) as num?)?.toInt() ??
          15,
      prepTimeMax:
          ((json['prep_time_max'] ?? json['prepTimeMax']) as num?)?.toInt() ??
          45,

      minOrderAmount: _double(
        json['min_order_amount'] ?? json['minOrderAmount'],
        fallback: 0,
      ),
      delivery: RestaurantDeliverySettings.fromJson(
        (json['delivery'] as Map?)?.cast<String, dynamic>(),
      ),

      currency: (json['currency'] as String?) ?? 'UZS',
      commissionPercent: _double(
        json['commission_percent'] ?? json['commissionPercent'],
        fallback: 0,
      ),
      payout: RestaurantPayout.fromJson(
        (json['payout'] as Map?)?.cast<String, dynamic>(),
      ),

      ratingAvg: _double(json['rating_avg'] ?? json['ratingAvg'], fallback: 0),
      ratingCount:
          ((json['rating_count'] ?? json['ratingCount']) as num?)?.toInt() ?? 0,

      metrics: RestaurantMetrics.fromJson(
        (json['metrics'] as Map?)?.cast<String, dynamic>(),
      ),

      createdAt: _parseDt(json['createdAt']),
      updatedAt: _parseDt(json['updatedAt']),
    );
  }

  /// TO JSON (API-friendly)
  ///
  /// Uses the new nested object shape (address/location/delivery/etc).
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'ownerUserId': ownerUserId,
      'cuisineTypeId': cuisineTypeId,
      'status': restaurantStatusToJson(status),

      'name': name,
      'description': description,
      'phone': phone,

      'address': address.toJson(),
      'location': location?.toJson(),

      'logo_url': logoUrl,
      'logo_public_id': logoPublicId,
      'banner_url': bannerUrl,
      'banner_public_id': bannerPublicId,
      'gallery_urls': galleryUrls,

      'cuisine_types': cuisineTypes,
      'tags': tags,
      'price_tier': priceTierToJson(priceTier),

      'is_open': isOpen,
      'accepting_orders': acceptingOrders,
      'temporarily_closed_reason': temporarilyClosedReason,
      'hours_json': hoursJson,
      'timezone': timezone,

      'fulfillment_modes': fulfillmentModes.map(fulfillmentModeToJson).toList(),
      'payment_methods': paymentMethods.map(paymentMethodToJson).toList(),
      'supports_scheduled_orders': supportsScheduledOrders,
      'auto_accept_orders': autoAcceptOrders,

      'prep_time_min': prepTimeMin,
      'prep_time_max': prepTimeMax,

      'min_order_amount': minOrderAmount,
      'delivery': delivery.toJson(),

      'currency': currency,
      'commission_percent': commissionPercent,
      'payout': payout.toJson(),

      'rating_avg': ratingAvg,
      'rating_count': ratingCount,

      'metrics': metrics.toJson(),

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Optional: If you still need to POST legacy flat fields somewhere.
  Map<String, dynamic> toLegacyFlatJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'address_line1': address.line1,
      'address_line2': address.line2 ?? '',
      'city': address.city,
      'region': address.region,
      'postal_code': address.postalCode ?? '',
      'lat': lat,
      'lng': lng,
      'is_open': isOpen,
      'min_order_amount': minOrderAmount,
      'delivery_fee_base': delivery.feeBase,
      'banner_url': bannerUrl ?? '',
      'banner_public_id': bannerPublicId ?? '',
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Dummy restaurant to avoid null state in cubit
  factory RestaurantModel.empty({
    String id = '',
    String ownerUserId = '',
    String cuisineTypeId = '',
  }) {
    final now = DateTime.now();

    return RestaurantModel(
      id: id,
      ownerUserId: ownerUserId,
      cuisineTypeId: cuisineTypeId,
      status: RestaurantStatus.active,

      name: '',
      description: null,
      phone: '',

      address: const RestaurantAddress(line1: '', city: '', region: ''),

      location: const GeoPoint(lng: 0, lat: 0),

      logoUrl: null,
      logoPublicId: null,
      bannerUrl: null,
      bannerPublicId: null,
      galleryUrls: const [],

      cuisineTypes: const [],
      tags: const [],
      priceTier: null,

      isOpen: false,
      acceptingOrders: false,
      temporarilyClosedReason: null,
      hoursJson: null,
      timezone: null,

      fulfillmentModes: const [FulfillmentMode.delivery],
      paymentMethods: const [PaymentMethod.cash],
      supportsScheduledOrders: false,
      autoAcceptOrders: false,

      prepTimeMin: 15,
      prepTimeMax: 30,
      minOrderAmount: 0,

      delivery: const RestaurantDeliverySettings(
        radiusKm: 8,
        feeBase: 0,
        freeOverAmount: 0,
      ),

      currency: 'UZS',
      commissionPercent: 0,
      payout: const RestaurantPayout(enabled: false),

      ratingAvg: 0,
      ratingCount: 0,

      metrics: const RestaurantMetrics(activeOrdersCount: 0),

      createdAt: now,
      updatedAt: now,
    );
  }
}
