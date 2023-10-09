import '../../data/model/credit_card_pie_performance_model.dart';

abstract class CreditCardPiePerformanceState {}

class CreditCardPiePerformanceInitial extends CreditCardPiePerformanceState {}

class CreditCardPiePerformanceLoading extends CreditCardPiePerformanceState {}

class CreditCardPiePerformanceError extends CreditCardPiePerformanceState {
  final String errorMsg;

  CreditCardPiePerformanceError(this.errorMsg);
}

class CreditCardPiePerformanceLoaded extends CreditCardPiePerformanceState {
  final List<CreditCardPiePerformanceModel> creditCardPiePerformanceModel;

  CreditCardPiePerformanceLoaded(this.creditCardPiePerformanceModel);
}
