import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/tenant_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repository/user_account_repo.dart';

class GetTenantUseCase extends UseCase<TenantModel, NoParams> {
  final UserAccountRepo userAccountRepo;

  GetTenantUseCase(this.userAccountRepo);

  @override
  Future<Either<Failure, TenantModel>> call(NoParams noParams) {
    return userAccountRepo.getTenant();
  }
}
