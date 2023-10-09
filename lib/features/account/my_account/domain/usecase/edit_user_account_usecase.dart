import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/account/my_account/domain/usecase/params/edit_user_account_params.dart';

import '../repository/user_account_repo.dart';

class EditUserAccountUseCase
    extends UseCase<UserAccountDataEntity, EditUserAccountParams> {
  final UserAccountRepo userAccountRepo;

  EditUserAccountUseCase(this.userAccountRepo);

  @override
  Future<Either<Failure, UserAccountDataEntity>> call(
      EditUserAccountParams params) {
    return userAccountRepo.editUserDetails(params);
  }
}
