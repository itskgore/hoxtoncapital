import '../../data/model/pension_performance_model.dart';

abstract class YourPensionsPerformanceState {}

class YourPensionsPerformanceInitial extends YourPensionsPerformanceState {}

class YourPensionsPerformanceLoading extends YourPensionsPerformanceState {}

class YourPensionsPerformanceError extends YourPensionsPerformanceState {
  final String errorMsg;

  YourPensionsPerformanceError(this.errorMsg);
}

class YourPensionPerformanceLoaded extends YourPensionsPerformanceState {
  final PensionPerformanceModel pensionPerformanceModel;
  final List<dynamic> data;
  final bool isFiltered;

  YourPensionPerformanceLoaded(
      {required this.pensionPerformanceModel,
      required this.data,
      required this.isFiltered});
}
