import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/data/datasource/remote_add_crypto_datasource.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/repository/add_cryto_repository.dart';
import 'package:wedge/features/assets/crypto/add_crypto_manual/domain/usecases/params/add_update_cryto_params.dart';

class AddUpdateCryptoRepoImp implements AddUpdateCryptoRepo {
  AddUpdateCryptoRepoImp({required this.remoteAddUpdateCryptoDataSource});

  final RemoteAddUpdateCryptoDataSource remoteAddUpdateCryptoDataSource;

  @override
  Future<Either<Failure, CryptoCurrenciesEntity>> addCrypto(
      AddUpdateCryptoParams params) async {
    try {
      final result =
          await remoteAddUpdateCryptoDataSource.addCryptoData(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CryptoCurrenciesEntity>> udpateCrypto(
      AddUpdateCryptoParams params) async {
    try {
      final result = await remoteAddUpdateCryptoDataSource
          .udpateCryptoData(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
