import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/crypto/crypto_main/data/datasource/local_cryto_datasource.dart';
import 'package:wedge/features/assets/crypto/crypto_main/data/datasource/remote_cryto_datasource.dart';
import 'package:wedge/features/assets/crypto/crypto_main/domain/repository/crypto_repository.dart';

import '../models/crypto_performance_model.dart';

class CryptoCurrenciesRepoImp implements CryptoRepo {
  CryptoCurrenciesRepoImp(
      {required this.remoteCryptoDataSrouce,
      required this.localCryptoCurrenciesDataSource});

  final RemoteCryptoDataSrouce remoteCryptoDataSrouce;
  final LocalCryptoCurrenciesDataSource localCryptoCurrenciesDataSource;

  @override
  Future<Either<Failure, CryptoCurrenciesEntity>> deleteCrypto(
      String id) async {
    try {
      final result = await remoteCryptoDataSrouce.deleteCrypto(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, AssetsEntity>> getCrypto() async {
    try {
      final result = await localCryptoCurrenciesDataSource.getCryptoData();
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, CryptoPerformanceModel>> getCryptoPerformance({
    required bool merge,
    required List scope,
    required String fromDate,
    required String toDate,
    String? assetType,
    String? id,
  }) async {
    try {
      final result = await localCryptoCurrenciesDataSource.getCryptoPerformance(
          merge: merge,
          scope: scope,
          fromDate: fromDate,
          toDate: toDate,
          assetType: assetType,
          id: id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
