import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/change_password/domain/model/change_password_params_model.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, dynamic>> changePassword(
      {required ChangePasswordParams changePasswordParams});
}
