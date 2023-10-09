import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/change_password/data/datasource/change_password_datasource.dart';
import 'package:wedge/features/change_password/domain/model/change_password_params_model.dart';
import 'package:wedge/features/change_password/domain/repository/change_password_repository.dart';

class ChangePasswordRepositoryImp extends ChangePasswordRepository {
  final ChangePasswordDatasource changePasswordDatasource;

  ChangePasswordRepositoryImp(this.changePasswordDatasource);

  @override
  Future<Either<Failure, dynamic>> changePassword(
      {required ChangePasswordParams changePasswordParams}) async {
    try {
      final res =
          await changePasswordDatasource.changePassword(changePasswordParams);
      return Right(res);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
