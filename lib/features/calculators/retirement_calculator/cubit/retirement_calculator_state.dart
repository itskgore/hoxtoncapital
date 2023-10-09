part of 'retirement_calculator_cubit.dart';

@immutable
abstract class RetirementCalculatorState {}

class RetirementCalculatorInitial extends RetirementCalculatorState {}

class RetirementCalculatorLoaded extends RetirementCalculatorState {}

class RetirementCalculatorLoading extends RetirementCalculatorState {}

class RetirementCalculatorError extends RetirementCalculatorState {}
