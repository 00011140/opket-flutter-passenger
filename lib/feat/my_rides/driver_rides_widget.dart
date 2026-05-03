import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:opket/core/di/sl.dart';
import 'package:opket/core/theme/colors.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/core/widgets/app_card.dart';
import 'package:opket/feat/my_rides/driver_ride.dart';

import 'driver_rides_api.dart';

class DriverRidesPage extends StatefulWidget {
  final String tz;
  const DriverRidesPage({super.key, this.tz = "UTC"});

  @override
  State<DriverRidesPage> createState() => _DriverRidesPageState();
}

class _DriverRidesPageState extends State<DriverRidesPage> {
  late final DriverRidesApi api;

  DateTime anchorDate = DateTime.now();

  bool loading = false;
  String? error;

  List<DriverRide> rides = [];
  int? cacheTs;

  final df = DateFormat("yyyy-MM-dd");
  final itemDf = DateFormat("d MMM, HH:mm");

  @override
  void initState() {
    super.initState();
    api = DriverRidesApi();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      loading = true;
      error = null;
    });

    final dateStr = df.format(anchorDate);

    try {
      final ts = await api.getCacheTimestampMs(
        period: "month",
        date: dateStr,
        tz: widget.tz,
      );

      final result = await api.getRidesCacheFirst(
        period: "month",
        date: dateStr,
        tz: widget.tz,
      );

      final sorted = result.fresh
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (!mounted) return;

      setState(() {
        rides = sorted;
        cacheTs = ts;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => error = e.toString());
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: anchorDate,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked == null) return;

    setState(() => anchorDate = picked);
    await _load();
  }

  /// ✅ GROUP BY MONTH
  Map<String, List<DriverRide>> _groupByMonth(List<DriverRide> rides) {
    final Map<String, List<DriverRide>> grouped = {};

    for (final ride in rides) {
      final local = ride.createdAt.toLocal();
      final key = DateFormat("MMMM yyyy").format(local);

      grouped.putIfAbsent(key, () => []).add(ride);
    }

    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return {for (final k in sortedKeys) k: grouped[k]!};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final cardColor = cs.surfaceContainerHighest.withOpacity(0.35);

    final grouped = _groupByMonth(rides);

    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat("MMMM yyyy").format(anchorDate)),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: _pickDate,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loading ? null : _load,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: error != null
              ? Center(child: Text("Xatolik: $error"))
              : rides.isEmpty && loading
              ? const Center(child: CircularProgressIndicator())
              : rides.isEmpty
              ? const Center(child: Text("Safarlar topilmadi"))
              : ListView(
                  children: grouped.entries.map((entry) {
                    final month = entry.key;
                    final monthRides = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔥 MONTH HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            month,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// 🔥 RIDES
                        ...monthRides.map(
                          (ride) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _RideCardModern(
                              ride: ride,
                              itemDf: itemDf,
                              cardColor: cardColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ),
    );
  }
}

class _RideCardModern extends StatelessWidget {
  final DriverRide ride;
  final DateFormat itemDf;
  final Color cardColor;

  const _RideCardModern({
    required this.ride,
    required this.itemDf,
    required this.cardColor,
  });

  String _statusUz(String? s) {
    switch (s) {
      case "pending":
        return "Kutilmoqda";
      case "accepted":
        return "Qabul qilingan";
      case "arrived":
        return "Yetib kelgan";
      case "started":
        return "Boshlangan";
      case "completed":
        return "Yakunlangan";
      case "cancelled":
        return "Bekor qilingan";
      default:
        return (s == null || s.isEmpty) ? "Noma'lum" : s;
    }
  }

  Color _statusColor(ColorScheme cs, String? status) {
    switch (status) {
      case "completed":
        return AppColors.success; // green-ish if your scheme is green
      case "cancelled":
        return AppColors.error;
      case "pending":
        return cs.secondary;
      case "started":
      case "accepted":
      case "arrived":
        return Colors.white;
      default:
        return cs.onSurface.withOpacity(0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final dateText = itemDf.format(ride.createdAt.toLocal());

    // Narx: agar cents bo‘lsa /100. Agar UZS bo‘lsa, /100 ni olib tashlang.
    final fareUzs = ride.fare; // <-- kerak bo‘lsa o‘zgartiring
    final fareText = NumberFormat(
      "#,##0",
      "en_US",
    ).format(fareUzs); // 22 300 kabi chiqadi

    // Masofa: siz “KM” dedingiz. Agar metr bo‘lsa: /1000
    final km = ride
        .distanceTraveled; // <-- agar metr bo‘lsa: ride.distanceTraveled / 1000.0
    final kmText = km.toStringAsFixed(2);

    final statusUz = _statusUz(ride.status);
    final sColor = _statusColor(cs, ride.status);

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: fareText,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const TextSpan(
                      text: " so'm",
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: kmText,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const TextSpan(
                      text: ' km',
                      style: TextStyle(fontSize: 24, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusPillModern(color: sColor, text: statusUz),
              Text(
                dateText,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPillModern extends StatelessWidget {
  final Color color;
  final String text;
  const _StatusPillModern({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w900,
          color: color,
        ),
      ),
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;

  const _IconPillButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest.withOpacity(0.55),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: cs.onSurface.withOpacity(0.85)),
      ),
    );
  }
}

class _ErrorCardModernUz extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final Color cardColor;

  const _ErrorCardModernUz({
    required this.message,
    required this.onRetry,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: cs.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Xatolik: $message",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withOpacity(0.9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 10),
          TextButton(onPressed: onRetry, child: const Text("Qayta urinish")),
        ],
      ),
    );
  }
}

class _ModernSkeletonList extends StatelessWidget {
  final Color cardColor;
  const _ModernSkeletonList({required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget pill() => Container(
      height: 14,
      width: 78,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(0.55),
        borderRadius: BorderRadius.circular(999),
      ),
    );

    return ListView.separated(
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.22),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.55),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 140,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      pill(),
                      const SizedBox(width: 10),
                      pill(),
                      const SizedBox(width: 10),
                      pill(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
