import 'package:opket/core/di/sl.dart';
import 'package:opket/core/services/api_client.dart';

class CancelReason {
  final String key;
  final String labelUz;
  final int order;

  const CancelReason({
    required this.key,
    required this.labelUz,
    required this.order,
  });

  factory CancelReason.fromJson(Map<String, dynamic> json) => CancelReason(
        key: json['key'] as String,
        labelUz: json['labelUz'] as String,
        order: (json['order'] ?? 0) as int,
      );
}

/// Loads the active cancellation reasons from the backend. Cached for the
/// session so the bottom sheet opens instantly the second time.
class CancelReasonsService {
  static List<CancelReason>? _cached;
  static Future<List<CancelReason>>? _inFlight;

  static Future<List<CancelReason>> load({bool force = false}) {
    if (!force && _cached != null) return Future.value(_cached!);
    return _inFlight ??= _fetch();
  }

  static Future<List<CancelReason>> _fetch() async {
    try {
      final res = await sl<ApiClient>().get('/ride/cancel-reasons');
      final data = res.data;
      final raw = data is Map<String, dynamic> ? data['reasons'] : null;
      final list = raw is List
          ? raw
              .map((e) => CancelReason.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : <CancelReason>[];
      list.sort((a, b) => a.order.compareTo(b.order));
      _cached = list;
      return list;
    } catch (_) {
      return _cached ?? const <CancelReason>[];
    } finally {
      _inFlight = null;
    }
  }
}
