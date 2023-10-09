part of 'search_crypto_cubit.dart';

@immutable
abstract class SearchCryptoState {}

class SearchCryptoInitial extends SearchCryptoState {}

class SearchCryptoLoading extends SearchCryptoState {}

class SearchCryptoLoaded extends SearchCryptoState {
  final List<SearchStocksCryptoEntity> data;
  final Map<String, dynamic> dataCurrency;

  SearchCryptoLoaded({required this.data, required this.dataCurrency});
}

class SearchCryptoError extends SearchCryptoState {
  final String errorMsg;

  SearchCryptoError({required this.errorMsg});
}
