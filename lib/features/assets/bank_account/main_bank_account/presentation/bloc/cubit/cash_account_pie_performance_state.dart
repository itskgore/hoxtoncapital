import '../../../data/model/cash_account_pie_performance_model.dart';

abstract class CashAccountPiePerformanceState {}

class CashAccountPiePerformanceInitial extends CashAccountPiePerformanceState {}

class CashAccountPiePerformanceLoading extends CashAccountPiePerformanceState {}

class CashAccountPiePerformanceError extends CashAccountPiePerformanceState {
  final String errorMsg;

  CashAccountPiePerformanceError(this.errorMsg);
}

class CashAccountPiePerformanceLoaded extends CashAccountPiePerformanceState {
  final List<CashAccountPiePerformanceModel> cashAccountPiePerformanceModel;

  CashAccountPiePerformanceLoaded(this.cashAccountPiePerformanceModel);
}
