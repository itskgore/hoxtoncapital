import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/create_password/data/datasource/create_password_datasource.dart';
import 'package:wedge/features/auth/create_password/domain/repository/create_password_repo.dart';

class CreatePasswordRepoImp implements CreatePasswordRepo {
  final CreatePasswordDataSource createPasswordDataSource;

  CreatePasswordRepoImp({required this.createPasswordDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> createPassword(
      Map<String, dynamic> body) async {
    try {
      final response = await createPasswordDataSource.createPassword(body);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
