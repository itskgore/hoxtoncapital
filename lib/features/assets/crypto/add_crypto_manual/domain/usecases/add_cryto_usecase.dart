import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/repository/add_cryto_repository.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/params/add_update_cryto_params.dart';

class AddCryptoUsecase
    extends UseCase<CryptoCurrenciesEntity, AddUpdateCryptoParams> {
  AddCryptoUsecase(this.addUpdateCryptoRepo);

  final AddUpdateCryptoRepo addUpdateCryptoRepo;

  @override
  Future<Either<Failure, CryptoCurrenciesEntity>> call(
      AddUpdateCryptoParams params) {
    return addUpdateCryptoRepo.addCrypto(params);
  }
}
