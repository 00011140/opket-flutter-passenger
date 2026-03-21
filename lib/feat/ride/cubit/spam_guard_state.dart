class SpamGuardState {
  final bool blocked;
  final Duration timeLeft;

  const SpamGuardState({required this.blocked, required this.timeLeft});

  factory SpamGuardState.initial() =>
      const SpamGuardState(blocked: false, timeLeft: Duration.zero);

  SpamGuardState copyWith({bool? blocked, Duration? timeLeft}) =>
      SpamGuardState(
        blocked: blocked ?? this.blocked,
        timeLeft: timeLeft ?? this.timeLeft,
      );
}
