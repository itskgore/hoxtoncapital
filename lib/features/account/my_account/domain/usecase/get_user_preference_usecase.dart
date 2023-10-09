import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/user_preferences_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../repository/user_account_repo.dart';

class GetUserPreferenceUseCase
    extends UseCase<UserPreferencesEntity, NoParams> {
  final UserAccountRepo userAccountRepo;

  GetUserPreferenceUseCase(this.userAccountRepo);

  @override
  Future<Either<Failure, UserPreferencesEntity>> call(NoParams params) {
    return userAccountRepo.getUserPreferences();
  }
}
