import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

import '../../domain/repository/signup_details_repo.dart';
import '../datasource/remote_signup_datasource.dart';

class SignUpRepositoryImp implements SignUpRepository {
  final SignUpDataSource signUpSource;

  SignUpRepositoryImp({required this.signUpSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateSignUpData(
      Map<String, dynamic> body) async {
    try {
      final result = await signUpSource.updateSignUpDetails(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> validateUserDetails(
      Map<String, dynamic> body) async {
    try {
      final result = await signUpSource.validateUserDetails(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LoginModel>> loginWithToken(
      {required String token}) async {
    try {
      final verifiedUser = await signUpSource.loginWithToken(token: token);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
