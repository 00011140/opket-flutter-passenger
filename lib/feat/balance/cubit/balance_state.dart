part of 'balance_cubit.dart';

abstract class BalanceState {}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceDeductionRequest extends BalanceState {
  final PayFareModel payFareData;
  BalanceDeductionRequest({required this.payFareData});
}

class BalanceTopUp extends BalanceState {
  final int amount;
  BalanceTopUp({required this.amount});
}

class BalanceSuccess extends BalanceState {
  final int balance;
  final bool canReceiveOffers;
  BalanceSuccess({required this.balance, required this.canReceiveOffers});
}

class BalanceError extends BalanceState {
  final String message;
  BalanceError({required this.message});
}
