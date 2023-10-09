import '../../data/model/Investment_performance_model.dart';

abstract class YourInvestmentPerformanceState {}

class YourInvestmentPerformanceInitial extends YourInvestmentPerformanceState {}

class YourInvestmentPerformanceLoading extends YourInvestmentPerformanceState {}

class YourInvestmentPerformanceError extends YourInvestmentPerformanceState {
  final String errorMsg;

  YourInvestmentPerformanceError(this.errorMsg);
}

class YourInvestmentPerformanceLoaded extends YourInvestmentPerformanceState {
  final InvestmentPerformanceModel investmentPerformanceModel;
  final List<dynamic> data;
  final bool isFiltered;

  YourInvestmentPerformanceLoaded(
      {required this.investmentPerformanceModel,
      required this.data,
      required this.isFiltered});
}
