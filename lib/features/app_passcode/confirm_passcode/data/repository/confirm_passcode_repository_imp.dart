import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/app_passcode/confirm_passcode/data/datasource/remote_confirm_passcode_datasource.dart';
import 'package:wedge/features/app_passcode/confirm_passcode/domain/repository/confirm_passcode_repository.dart';

class ConfirmPasscodeRepositoryImp extends ConfirmPasscodeRepository {
  final RemoteConfirmPasscodeDataSource remoteConfirmPasscodeDataSource;

  ConfirmPasscodeRepositoryImp(this.remoteConfirmPasscodeDataSource);

  @override
  Future<Either<Failure, dynamic>> confirmPasscode(
      {required String email, required String passcode}) async {
    try {
      final result = await remoteConfirmPasscodeDataSource.confirmPasscode(
          email: email, passcode: passcode);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
