abstract class CashAccountBarPerformanceState {}

class CashAccountBarPerformanceInitial extends CashAccountBarPerformanceState {}

class CashAccountBarPerformanceLoading extends CashAccountBarPerformanceState {}

class CashAccountBarPerformanceError extends CashAccountBarPerformanceState {
  final String errorMsg;

  CashAccountBarPerformanceError(this.errorMsg);
}

class CashAccountBarPerformanceLoaded extends CashAccountBarPerformanceState {
  final List<dynamic> cashAccountBarPerformanceList;

  CashAccountBarPerformanceLoaded(this.cashAccountBarPerformanceList);
}
