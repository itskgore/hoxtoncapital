import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

class LoginUser implements UseCase<LoginUserEntity, LoginParams> {
  final LoginRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, LoginUserEntity>> call(LoginParams params) async {
    return await repository.login(
        params.email, params.password, params.isTermsAndConditionsAccepted);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;
  final String? passCode;
  final bool? isOTPVerified;
  final bool isTermsAndConditionsAccepted;

  LoginParams(
      {required this.email,
      required this.password,
      this.passCode,
      this.isOTPVerified,
      required this.isTermsAndConditionsAccepted});

  @override
  List<Object> get props => [email, password];
}
