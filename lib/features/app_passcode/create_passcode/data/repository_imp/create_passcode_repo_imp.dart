import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/app_passcode/create_passcode/data/datasource/remote_create_passcode_datasource.dart';
import 'package:wedge/features/app_passcode/create_passcode/domain/repository/create_passcode_repository.dart';

class CreatePasscodeRepositoryImp extends CreatePasscodeRepository {
  final RemoteCreatePasscodeDatasource remoteCreatePasscodeDatasource;

  CreatePasscodeRepositoryImp(this.remoteCreatePasscodeDatasource);

  @override
  Future<Either<Failure, dynamic>> createPasscode(
      Map<String, dynamic> body) async {
    try {
      final result = await remoteCreatePasscodeDatasource.createPasscode(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
