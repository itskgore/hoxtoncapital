import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/create_password/domain/repository/create_password_repo.dart';

class CreatePasswordUsecase
    extends UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final CreatePasswordRepo createPasswordRepo;

  CreatePasswordUsecase(this.createPasswordRepo);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) {
    return createPasswordRepo.createPassword(params);
  }
}
