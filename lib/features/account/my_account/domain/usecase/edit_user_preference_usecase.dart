import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/user_preferences_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repository/user_account_repo.dart';

class EditUserPreferencesUseCase
    extends UseCase<UserPreferencesEntity, Map<String, dynamic>> {
  final UserAccountRepo userAccountRepo;

  EditUserPreferencesUseCase(this.userAccountRepo);

  @override
  Future<Either<Failure, UserPreferencesEntity>> call(
      Map<String, dynamic> params) {
    return userAccountRepo.editUserPreferences(params, params['id']);
  }
}
