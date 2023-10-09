import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/stocks/search_stocks/domain/usecases/get_search_stocks.dart';
import 'package:wedge/features/assets/stocks/search_stocks/domain/usecases/get_stocks_currency.dart';

part 'search_stocks_state.dart';

class SearchStocksCubit extends Cubit<SearchStocksState> {
  final GetStocksData getStocksData;
  final GetStocksCurrency getStocksCurrency;

  SearchStocksCubit(
      {required this.getStocksData, required this.getStocksCurrency})
      : super(SearchStocksInitial());

  late List<SearchStocksCryptoEntity> data;

  searchCrypto(String parameter) {
    emit(SearchStocksLoading());
    final result = getStocksData(parameter);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          searchCrypto(parameter);
        } else {
          emit(SearchStocksError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        data = r;
        emit(SearchStocksLoaded(data: r, dataCurrency: {}));
      });
    });
  }

  getCryptoCurrencyData(String parameter) {
    emit(SearchStocksLoading());
    final result = getStocksCurrency(parameter);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCryptoCurrencyData(parameter);
        } else {
          emit(SearchStocksError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(SearchStocksLoaded(data: data, dataCurrency: r));
      });
    });
  }
}
