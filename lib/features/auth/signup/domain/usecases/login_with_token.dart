import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/auth/signup/domain/repository/signup_details_repo.dart';

class LoginWithToken implements UseCase<LoginModel, String> {
  final SignUpRepository repository;

  LoginWithToken(this.repository);

  @override
  Future<Either<Failure, LoginModel>> call(String token) async {
    return await repository.loginWithToken(token: token);
  }
}
