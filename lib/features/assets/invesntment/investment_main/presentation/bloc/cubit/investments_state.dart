part of 'investments_cubit.dart';

@immutable
abstract class InvestmentsState {}

class InvestmentsInitial extends InvestmentsState {}

class InvestmentsLoading extends InvestmentsState {}

class InvestmentsLoaded extends InvestmentsState {
  final AssetsEntity assets;
  final bool deleteMessageSent;

  InvestmentsLoaded({required this.assets, required this.deleteMessageSent});
}

class InvestmentsError extends InvestmentsState {
  final String errorMsg;

  InvestmentsError(this.errorMsg);
}
