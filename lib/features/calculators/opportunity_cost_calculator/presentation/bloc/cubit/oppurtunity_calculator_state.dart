part of 'oppurtunity_calculator_cubit.dart';

@immutable
abstract class OppurtunityCalculatorState {}

class OppurtunityCalculatorInitial extends OppurtunityCalculatorState {
  final double annualReturn;
  final int investmentPeriod;
  final double annualInflation;
  final double interestEarned;
  final double totalValue;
  final double moneyTospend;

  OppurtunityCalculatorInitial(
      {required this.annualReturn,
      required this.investmentPeriod,
      required this.annualInflation,
      required this.interestEarned,
      required this.totalValue,
      required this.moneyTospend});
}

// class OppurtunityCalculatorLoaded extends OppurtunityCalculatorState {
//   final double annualReturn;
//   final int investmentPeriod;
//   final double annualInflation;
//   final double interestEarned;
//   final double totalValue;

//   OppurtunityCalculatorLoaded(
//       {required this.annualReturn,
//       required this.investmentPeriod,
//       required this.annualInflation,
//       required this.interestEarned,
//       required this.totalValue});
// }
