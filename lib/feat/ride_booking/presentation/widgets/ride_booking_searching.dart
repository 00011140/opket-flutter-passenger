part of '../index.dart';

class RideBookingSearching extends StatefulWidget {
  const RideBookingSearching({
    super.key,
    required this.candidateDrivers,
    required this.searchDurationMs,
    this.searchStartedAtMs,
  });

  final List<DriverLocation> candidateDrivers;
  final int searchDurationMs;
  final int? searchStartedAtMs;

  @override
  State<RideBookingSearching> createState() => _RideBookingSearchingState();
}

class _RideBookingSearchingState extends State<RideBookingSearching> {
  late int _remainingMs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingMs = _computeRemaining();
    _startTimer();
  }

  @override
  void didUpdateWidget(RideBookingSearching oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchDurationMs != widget.searchDurationMs ||
        oldWidget.searchStartedAtMs != widget.searchStartedAtMs) {
      _timer?.cancel();
      _remainingMs = _computeRemaining();
      _startTimer();
    }
  }

  int _computeRemaining() {
    final startedAt = widget.searchStartedAtMs;
    if (startedAt == null) return widget.searchDurationMs;
    final elapsed = DateTime.now().millisecondsSinceEpoch - startedAt;
    return (widget.searchDurationMs - elapsed).clamp(
      0,
      widget.searchDurationMs,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final remaining = _computeRemaining();
      if (mounted) setState(() => _remainingMs = remaining);
      if (remaining <= 0) {
        _timer?.cancel();
        _onSearchExpired();
      }
    });
  }

  void _onSearchExpired() {
    if (!mounted) return;
    final cubit = context.read<ActiveRideCubit>();
    if (cubit.state.status != RideStatus.searching) return;
    cubit.reset();
    ActiveRideCacheService.clearRideState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int ms) {
    final totalSeconds = (ms / 1000).ceil();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.black,
                        highlightColor: Colors.white,
                        child: Text(
                          widget.candidateDrivers.isEmpty
                              ? "Haydovchi qidiryapmiz"
                              : "${widget.candidateDrivers.length} ta haydovchi topildi",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        textAlign: TextAlign.start,
                        widget.candidateDrivers.isEmpty
                            ? "Iltimos vaqt tugaguncha kutib turing"
                            : "Haydovchilarga taklif yuborilmoqda",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm_md,
                    vertical: AppSpacing.sm,
                  ),
                  child: Text(
                    _formatTime(_remainingMs),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            const UseBalanceSwitch(),
            SizedBox(height: AppSpacing.md),
            const CancelRideButton(),
          ],
        ),
      ),
    );
  }
}
