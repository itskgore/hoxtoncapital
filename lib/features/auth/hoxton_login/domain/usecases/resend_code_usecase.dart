import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

import 'login.dart';

class ResendOTPusecase implements UseCase<int, LoginParams> {
  final LoginRepository repository;

  ResendOTPusecase(this.repository);

  @override
  Future<Either<Failure, int>> call(LoginParams params) async {
    return await repository.resendCode(params.email);
  }
}
