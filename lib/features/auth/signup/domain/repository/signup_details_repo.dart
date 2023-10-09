import 'package:dartz/dartz.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import '../../../../../core/error/failures.dart';

abstract class SignUpRepository {
  Future<Either<Failure, Map<String, dynamic>>> updateSignUpData(
      Map<String, dynamic> body);

  Future<Either<Failure, Map<String, dynamic>>> validateUserDetails(
      Map<String, dynamic> body);

  Future<Either<Failure, LoginModel>> loginWithToken({required String token});
}
