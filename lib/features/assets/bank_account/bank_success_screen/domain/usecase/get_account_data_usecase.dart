import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assest_liabiltiy_onboarding_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/domain/repository/get_account_data_repository.dart';

class GetAccountDataUsecase
    implements UseCase<AssetLiabilityOnboardingListEntity, ProviderParams> {
  final GetAccountDataRepository repository;

  GetAccountDataUsecase(this.repository);

  @override
  Future<Either<Failure, AssetLiabilityOnboardingListEntity>> call(
      ProviderParams params) async {
    return await repository.getAccountData(params.param);
  }
}

class ProviderParams {
  final String param;

  ProviderParams({required this.param});
}
