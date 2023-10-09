import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/crypto/crypto_main/domain/usecase/delete_crypto_usecase.dart';
import 'package:wedge/features/assets/crypto/crypto_main/domain/usecase/get_crypto_usecase.dart';

part 'main_crypto_bloc_state.dart';

class MainCryptoBlocCubit extends Cubit<MainCryptoBlocState> {
  final GetCryptoDataUsecase getCryptoData;
  final DeleteCryptoUsecase deleteCryptoUsecase;

  MainCryptoBlocCubit(
      {required this.getCryptoData, required this.deleteCryptoUsecase})
      : super(MainCryptoBlocInitial());
  late AssetsEntity _assetsEntity;

  getCryptoCurrencies() {
    final result = getCryptoData(NoParams());
    emit(MainCryptoBlocLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          getCryptoCurrencies();
        } else {
          emit(MainCryptoBlocError(errorMsg: failure.displayErrorMessage()));
        }
      }, (data) {
        _assetsEntity = data;
        emit(MainCryptoBlocLoaded(data: data, showDeleteMsg: false));
      });
    });
  }

  deleteCryptoCurrencies(String id) {
    final result = deleteCryptoUsecase(DeleteParams(id: id));
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          deleteCryptoCurrencies(id);
        } else {
          emit(MainCryptoBlocError(errorMsg: failure.displayErrorMessage()));
          emit(MainCryptoBlocLoaded(data: _assetsEntity, showDeleteMsg: false));
        }
      }, (data) {
        emit(MainCryptoBlocLoaded(data: _assetsEntity, showDeleteMsg: true));
      });
    });
  }
}
