import '../../data/models/crypto_performance_model.dart';

abstract class CryptoPerformanceState {}

class CryptoPerformanceInitial extends CryptoPerformanceState {}

class CryptoPerformanceLoading extends CryptoPerformanceState {}

class CryptoPerformanceError extends CryptoPerformanceState {
  final String errorMsg;

  CryptoPerformanceError(this.errorMsg);
}

class CryptoPerformanceLoaded extends CryptoPerformanceState {
  final CryptoPerformanceModel pensionPerformanceModel;
  final List<dynamic> data;
  final bool isFiltered;
  final String baseCurrency;

  CryptoPerformanceLoaded(
      {required this.pensionPerformanceModel,
      required this.baseCurrency,
      required this.data,
      required this.isFiltered});
}
