import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';

enum DiscountType { percentage, fixed }

DiscountType _parseType(dynamic raw) =>
    raw == 'percentage' ? DiscountType.percentage : DiscountType.fixed;

class DiscountTier {
  final int minFare;
  final int? maxFare;
  final DiscountType type;
  final num value;

  const DiscountTier({
    required this.minFare,
    required this.maxFare,
    required this.type,
    required this.value,
  });

  factory DiscountTier.fromJson(Map<String, dynamic> json) => DiscountTier(
        minFare: (json['minFare'] ?? 0).toInt(),
        maxFare: json['maxFare'] == null ? null : (json['maxFare'] as num).toInt(),
        type: _parseType(json['type']),
        value: (json['value'] ?? 0) as num,
      );
}

class DiscountConfig {
  final bool enabled;
  final List<DiscountTier> tiers;

  const DiscountConfig({required this.enabled, required this.tiers});

  const DiscountConfig.empty() : enabled = false, tiers = const [];

  factory DiscountConfig.fromJson(Map<String, dynamic> json) {
    final raw = json['tiers'];
    final list = raw is List
        ? raw
            .map((e) => DiscountTier.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList()
        : <DiscountTier>[];
    list.sort((a, b) => a.minFare.compareTo(b.minFare));
    return DiscountConfig(enabled: json['enabled'] == true, tiers: list);
  }

  int discountFor(int fare) {
    if (!enabled || tiers.isEmpty || fare <= 0) return 0;
    for (final tier in tiers) {
      final aboveMin = fare >= tier.minFare;
      final belowMax = tier.maxFare == null || fare < tier.maxFare!;
      if (aboveMin && belowMax) {
        final raw = tier.type == DiscountType.percentage
            ? fare * tier.value / 100
            : tier.value;
        final asInt = raw.round();
        if (asInt <= 0) return 0;
        return asInt > fare ? fare : asInt;
      }
    }
    return 0;
  }

  int discountedFare(int fare) =>
      (fare - discountFor(fare)).clamp(0, fare);

  bool appliesTo(int fare) => discountFor(fare) > 0;
}

/// Lightweight singleton: loads once per app session (or on demand) and
/// returns the cached config. Both the active-ride screen and ride-summary
/// screen call [load] then read [current].
class DiscountConfigService {
  static DiscountConfig _current = const DiscountConfig.empty();
  static Future<void>? _inFlight;

  static DiscountConfig get current => _current;

  static Future<DiscountConfig> load({bool force = false}) {
    if (!force && _inFlight != null) return _inFlight!.then((_) => _current);
    _inFlight = _fetch();
    return _inFlight!.then((_) => _current);
  }

  static Future<void> _fetch() async {
    try {
      final res = await sl<ApiClient>().get('/discount/config');
      final data = res.data;
      if (data is Map<String, dynamic>) {
        _current = DiscountConfig.fromJson(data);
      }
    } catch (_) {
      // Leave _current unchanged; UI degrades to showing original fare only.
    } finally {
      _inFlight = null;
    }
  }
}
