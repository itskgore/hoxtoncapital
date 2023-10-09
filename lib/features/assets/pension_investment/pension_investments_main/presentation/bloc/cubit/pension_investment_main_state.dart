part of 'pension_investment_main_cubit.dart';

@immutable
abstract class PensionInvestmentMainState {}

class PensionInvestmentMainInitial extends PensionInvestmentMainState {}

class PensionInvestmentMainLoading extends PensionInvestmentMainState {}

class PensionInvestmentMainLoaded extends PensionInvestmentMainState {
  final AssetsEntity data;
  final List performanceData;
  final String currency;
  final dynamic performanceAPIData;
  final bool isFiltered;

  PensionInvestmentMainLoaded({
    required this.data,
    required this.currency,
    required this.isFiltered,
    required this.performanceData,
    required this.performanceAPIData,
  });
}

class PensionInvestmentMainError extends PensionInvestmentMainState {
  final String errorMsg;

  PensionInvestmentMainError(this.errorMsg);
}
