import 'package:equatable/equatable.dart';

enum PremiumTaxiStatus { available, notAvailable }

class PremiumTaxiState extends Equatable {
  final bool premium;
  final PremiumTaxiStatus status;

  const PremiumTaxiState({
    this.premium = false,
    this.status = PremiumTaxiStatus.available,
  });

  PremiumTaxiState copyWith({bool? premium, PremiumTaxiStatus? status}) =>
      PremiumTaxiState(
        premium: premium ?? this.premium,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [premium, status];
}
