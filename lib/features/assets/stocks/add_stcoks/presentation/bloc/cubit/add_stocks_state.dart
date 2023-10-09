part of 'add_stocks_cubit.dart';

@immutable
abstract class AddStocksState {}

class AddStocksLoading extends AddStocksState {}

class AddStocksInitial extends AddStocksState {
  final status;
  final message;
  final data;

  AddStocksInitial(
      {required this.status, required this.message, required this.data});
}
