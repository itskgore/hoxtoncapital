part of 'your_investments_cubit.dart';

@immutable
abstract class YourInvestmentsState {}

class YourInvestmentsInitial extends YourInvestmentsState {}

class YourInvestmentsError extends YourInvestmentsState {
  final String errorMsg;

  YourInvestmentsError(this.errorMsg);
}

class YourInvestmentsLoading extends YourInvestmentsState {}

class YourInvestmentsLoaded extends YourInvestmentsState {
  final bool isDeletePerformed;
  final List<InvestmentHoldingsEntity> investmentHoldingsEntity;
  final Map<String, dynamic>? reconnctUrl;

  YourInvestmentsLoaded(
      {required this.investmentHoldingsEntity,
      required this.isDeletePerformed,
      this.reconnctUrl});
}
