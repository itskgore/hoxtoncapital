part of 'add_investment_cubit.dart';

@immutable
abstract class AddInvestmentState {}

class AddInvestmentLoading extends AddInvestmentState {}

class AddInvestmentInitial extends AddInvestmentState {
  final status;
  final message;
  final data;

  AddInvestmentInitial(
      {required this.status, required this.message, required this.data});
}
