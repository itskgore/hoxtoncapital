part of 'search_stocks_cubit.dart';

@immutable
abstract class SearchStocksState {}

class SearchStocksInitial extends SearchStocksState {}

class SearchStocksLoading extends SearchStocksState {}

class SearchStocksLoaded extends SearchStocksState {
  final List<SearchStocksCryptoEntity> data;
  final Map<String, dynamic> dataCurrency;

  SearchStocksLoaded({required this.data, required this.dataCurrency});
}

class SearchStocksError extends SearchStocksState {
  final String errorMsg;

  SearchStocksError({required this.errorMsg});
}
