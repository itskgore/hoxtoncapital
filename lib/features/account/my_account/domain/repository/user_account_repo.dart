import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/tenant_model.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/entities/user_preferences_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../usecase/params/edit_user_account_params.dart';

abstract class UserAccountRepo {
  Future<Either<Failure, UserAccountDataEntity>> getUserDetails();

  Future<Either<Failure, UserAccountDataEntity>> editUserDetails(
      EditUserAccountParams params);

  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences();

  Future<Either<Failure, UserPreferencesEntity>> editUserPreferences(
      Map<String, dynamic> body, String id);

  Future<Either<Failure, TenantModel>> getTenant();
}
