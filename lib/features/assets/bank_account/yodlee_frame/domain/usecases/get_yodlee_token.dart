import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/provider_token_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/yodlee_frame/domain/repositories/get_yodlee_token_repo.dart';

class GetProviderToken
    implements UseCase<ProviderTokenEntity, Map<String, dynamic>> {
  final GetYodleeTokenRepository repository;

  GetProviderToken(this.repository);

  @override
  Future<Either<Failure, ProviderTokenEntity>> call(
      Map<String, dynamic> params) async {
    return await repository.getYodleeToken(body: params);
  }
}
