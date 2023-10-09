import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/stocks_crypto_search_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/crypto/crypto_search/domain/usecases/get_crypto_currency.dart';
import 'package:wedge/features/assets/crypto/crypto_search/domain/usecases/get_crypto_data.dart';

part 'search_crypto_state.dart';

class SearchCryptoCubit extends Cubit<SearchCryptoState> {
  final GetCryptoCurrency getCryptoCurrency;
  final GetCryptoData getCryptoData;

  SearchCryptoCubit(
      {required this.getCryptoCurrency, required this.getCryptoData})
      : super(SearchCryptoInitial());
  late List<SearchStocksCryptoEntity> data;

  searchCrypto(String parameter) {
    emit(SearchCryptoLoading());
    final result = getCryptoData(parameter);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          searchCrypto(parameter);
        } else {
          emit(SearchCryptoError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        data = r;
        emit(SearchCryptoLoaded(data: r, dataCurrency: {}));
      });
    });
  }

  getCryptoCurrencyData(String parameter) {
    emit(SearchCryptoLoading());
    final result = getCryptoCurrency(parameter);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCryptoCurrencyData(parameter);
        } else {
          emit(SearchCryptoError(errorMsg: l.displayErrorMessage()));
        }
      }, (r) {
        emit(SearchCryptoLoaded(data: data, dataCurrency: r));
      });
    });
  }
}
