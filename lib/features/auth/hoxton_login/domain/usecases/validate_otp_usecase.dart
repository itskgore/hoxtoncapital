import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

import 'login.dart';

class ValidateOTPUsecase implements UseCase<LoginUserEntity, LoginParams> {
  final LoginRepository repository;

  ValidateOTPUsecase(this.repository);

  @override
  Future<Either<Failure, LoginUserEntity>> call(LoginParams params) async {
    return await repository.validateOTP(params.email, params.password);
  }
}
