import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/provider_token_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/data/data_sources/get_yodleee_token_datasource.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/domain/repositories/get_yodlee_token_repo.dart';

class GetYodleeTokenRepositoryImpl implements GetYodleeTokenRepository {
  final GetYodleeTokenDataSource dataSource;

  GetYodleeTokenRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, ProviderTokenModel>> getYodleeToken(
      {required Map<String, dynamic> body}) async {
    try {
      final result = await dataSource.getYodleeToken(
          body: body['data'], provider: body['provider']);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
