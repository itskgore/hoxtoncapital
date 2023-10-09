import '../../../data/models/stocks_performance_model.dart';

abstract class StocksPerformanceState {}

class StocksPerformanceInitial extends StocksPerformanceState {}

class StocksPerformanceLoading extends StocksPerformanceState {}

class StocksPerformanceError extends StocksPerformanceState {
  final String errorMsg;

  StocksPerformanceError(this.errorMsg);
}

class StocksPerformanceLoaded extends StocksPerformanceState {
  final StocksPerformanceModel pensionPerformanceModel;
  final List<dynamic> data;
  final bool isFiltered;
  final String baseCurrency;

  StocksPerformanceLoaded(
      {required this.pensionPerformanceModel,
      required this.data,
      required this.baseCurrency,
      required this.isFiltered});
}
