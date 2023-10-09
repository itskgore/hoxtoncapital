import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/add_cryto_usecase.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/params/add_update_cryto_params.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/udpate_cryto_usecase.dart';

part 'add_crypto_bloc_state.dart';

class AddCryptoBlocCubit extends Cubit<AddCryptoBlocState> {
  final AddCryptoUsecase addCryptoUsecase;
  final UpdateCryptoUsecase updateCryptoUsecase;

  AddCryptoBlocCubit(
      {required this.addCryptoUsecase, required this.updateCryptoUsecase})
      : super(AddCryptoBlocInitial());

  addCrypto(AddUpdateCryptoParams params) {
    final result = addCryptoUsecase(params);
    emit(AddCryptoBlocLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          addCrypto(params);
        } else {
          emit(AddCryptoBlocError(error: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(AddCryptoBlocLoaded());
      });
    });
  }

  udpateCrypto(AddUpdateCryptoParams params) {
    final result = updateCryptoUsecase(params);
    emit(AddCryptoBlocLoading());
    result.then((value) {
      value.fold((failure) {
        if (failure is TokenExpired) {
          udpateCrypto(params);
        } else {
          emit(AddCryptoBlocError(error: failure.displayErrorMessage()));
        }
      }, (data) {
        emit(AddCryptoBlocLoaded());
      });
    });
  }
}
