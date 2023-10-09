import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repository/user_account_repo.dart';

class GetUserAccountUseCase extends UseCase<UserAccountDataEntity, NoParams> {
  final UserAccountRepo userAccountRepo;

  GetUserAccountUseCase(this.userAccountRepo);

  @override
  Future<Either<Failure, UserAccountDataEntity>> call(NoParams params) {
    return userAccountRepo.getUserDetails();
  }
}
