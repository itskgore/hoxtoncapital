part of 'stocks_cubit.dart';

@immutable
abstract class StocksState {}

class StocksInitial extends StocksState {}

class StocksLoading extends StocksState {}

class StocksLoaded extends StocksState {
  final AssetsEntity assets;
  final bool deleteMessageSent;

  StocksLoaded({required this.assets, required this.deleteMessageSent});
}

class StocksError extends StocksState {
  final String errorMsg;

  StocksError(this.errorMsg);
}
