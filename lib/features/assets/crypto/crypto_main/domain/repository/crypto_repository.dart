import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../data/models/crypto_performance_model.dart';

abstract class CryptoRepo {
  Future<Either<Failure, AssetsEntity>> getCrypto();

  Future<Either<Failure, CryptoCurrenciesEntity>> deleteCrypto(String id);

  Future<Either<Failure, CryptoPerformanceModel>> getCryptoPerformance(
      {required bool merge,
      required List scope,
      required String fromDate,
      required String toDate,
      String? assetType,
      String? id});
}
