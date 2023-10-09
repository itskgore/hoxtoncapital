import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/model/change_passcode_params_model.dart';
import '../../domain/repository/change_passcode_repository.dart';
import '../datasource/change_passcode_datasource.dart';

class ChangePasscodeRepositoryImp extends ChangePasscodeRepository {
  final ChangePasscodeDatasource changePasscodeDatasource;

  ChangePasscodeRepositoryImp(this.changePasscodeDatasource);

  @override
  Future<Either<Failure, dynamic>> changePasscode(
      {required ChangePasscodeParams changePasswordParams}) async {
    try {
      final res =
          await changePasscodeDatasource.changePasscode(changePasswordParams);
      return Right(res);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
