import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/params/add_update_cryto_params.dart';

abstract class AddUpdateCryptoRepo {
  Future<Either<Failure, CryptoCurrenciesEntity>> addCrypto(
      AddUpdateCryptoParams params);

  Future<Either<Failure, CryptoCurrenciesEntity>> udpateCrypto(
      AddUpdateCryptoParams params);
}
