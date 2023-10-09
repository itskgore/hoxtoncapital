part of 'your_pensions_cubit.dart';

@immutable
abstract class YourPensionsState {}

class YourPensionsInitial extends YourPensionsState {}

class YourPensionsError extends YourPensionsState {
  final String errorMsg;

  YourPensionsError(this.errorMsg);
}

class YourPensionsLoading extends YourPensionsState {}

class YourPensionsLoaded extends YourPensionsState {
  final bool isDeletePerformed;
  final List<InvestmentHoldingsEntity> investmentHoldingsEntity;

  YourPensionsLoaded(this.investmentHoldingsEntity, this.isDeletePerformed);
}
