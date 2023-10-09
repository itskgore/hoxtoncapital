import '../../data/model/line_performance_model.dart';

abstract class LinePerformanceState {}

class LinePerformanceInitial extends LinePerformanceState {}

class LinePerformanceLoading extends LinePerformanceState {}

class LinePerformanceError extends LinePerformanceState {
  final String errorMsg;
  LinePerformanceError(this.errorMsg);
}

class LinePerformanceLoaded extends LinePerformanceState {
  final LinePerformanceModel linePerformanceModel;
  final List<dynamic> data;
  final bool isFiltered;
  final String baseCurrency;
  LinePerformanceLoaded(
      {required this.linePerformanceModel,
      required this.baseCurrency,
      required this.data,
      required this.isFiltered});
}
