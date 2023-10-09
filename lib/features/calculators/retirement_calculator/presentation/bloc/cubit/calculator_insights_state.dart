part of 'calculator_insights_cubit.dart';

@immutable
abstract class CalculatorInsightsState {}

class CalculatorInsightsInitial extends CalculatorInsightsState {}

class CalculatorInsightsLoading extends CalculatorInsightsState {}

class CalculatorInsightsLoaded extends CalculatorInsightsState {
  final InsightsEntity? data;

  CalculatorInsightsLoaded({required this.data});
}

class CalculatorInsightsError extends CalculatorInsightsState {}
