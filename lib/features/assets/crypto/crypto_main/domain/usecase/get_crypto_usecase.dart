import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/crypto/crypto_main/domain/repository/crypto_repository.dart';

import '../../data/models/crypto_performance_model.dart';

class GetCryptoDataUsecase extends UseCase<AssetsEntity, NoParams> {
  GetCryptoDataUsecase(this.cryptoRepo);

  final CryptoRepo cryptoRepo;

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) {
    return cryptoRepo.getCrypto();
  }
}

class GetCryptoPerformance
    extends UseCase<CryptoPerformanceModel, Map<String, dynamic>> {
  late CryptoRepo cryptoRepository;

  GetCryptoPerformance(this.cryptoRepository);

  @override
  Future<Either<Failure, CryptoPerformanceModel>> call(
      Map<String, dynamic> params) {
    return cryptoRepository.getCryptoPerformance(
      merge: params['merge'],
      scope: params['scope'],
      fromDate: params['fromDate'],
      toDate: params['toDate'],
      assetType: params['assetType'],
      id: params['id'],
    );
  }
}
