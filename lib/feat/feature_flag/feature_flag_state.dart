part of 'feature_flag_cubit.dart';

class FeatureFlagState extends Equatable {
  final bool isLuggageEnabled;

  const FeatureFlagState({this.isLuggageEnabled = true});

  FeatureFlagState copyWith({bool? isLuggageEnabled}) => FeatureFlagState(
    isLuggageEnabled: isLuggageEnabled ?? this.isLuggageEnabled,
  );

  factory FeatureFlagState.fromMap(Map<String, dynamic> map) {
    return FeatureFlagState(isLuggageEnabled: map['isLuggageEnabled'] ?? true);
  }

  @override
  List<Object?> get props => [isLuggageEnabled];
}
