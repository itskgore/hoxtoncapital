import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

import 'login.dart';

class LoginWithOTP implements UseCase<dynamic, LoginParams> {
  final LoginRepository repository;

  LoginWithOTP(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(LoginParams params) async {
    return await repository.loginWithOTP(
        params.email, params.password, params.isTermsAndConditionsAccepted,
        passcode: params.passCode, isOTPVerified: params.isOTPVerified);
  }
}
