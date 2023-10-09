import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/crypto/crypto_main/domain/repository/crypto_repository.dart';

class DeleteCryptoUsecase
    extends UseCase<CryptoCurrenciesEntity, DeleteParams> {
  DeleteCryptoUsecase(this.cryptoRepo);

  final CryptoRepo cryptoRepo;

  @override
  Future<Either<Failure, CryptoCurrenciesEntity>> call(DeleteParams params) {
    return cryptoRepo.deleteCrypto(params.id);
  }
}
