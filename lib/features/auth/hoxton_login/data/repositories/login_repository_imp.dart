import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/data/data_sources/local_login_data_source.dart';
import 'package:wedge/features/auth/hoxton_login/data/data_sources/login_data_source.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;
  final LocalLoginDataSource localLoginDataSource;

  LoginRepositoryImpl(
      {required this.loginDataSource, required this.localLoginDataSource});

  @override
  Future<Either<Failure, LoginEmailEntity>> verifyEmail(String email) async {
    try {
      final verifiedUser = await loginDataSource.verifyEmail(email);
      localLoginDataSource.saveEmailUser(verifiedUser);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LoginUserEntity>> login(
      String email, String password, bool isTermsAndConditionsAccepted) async {
    try {
      final verifiedUser = await loginDataSource.login(
          email, password, isTermsAndConditionsAccepted);

      localLoginDataSource.saveToken(verifiedUser);

      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String email) async {
    try {
      final bool response = await loginDataSource.resetPassword(email);
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, dynamic>> loginWithOTP(
      String email, String password, bool isTermsAndConditionsAccepted,
      {String? passcode, bool? isOTPVerified}) async {
    try {
      final verifiedUser = await loginDataSource.loginWithOTP(
          email, password, isTermsAndConditionsAccepted,
          passcode: passcode, isOTPVerified: isOTPVerified);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LoginUserEntity>> validateOTP(
      String email, String password) async {
    try {
      final verifiedUser = await loginDataSource.validateOtp(email, password);
      localLoginDataSource.saveToken(verifiedUser);

      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, int>> resendCode(String email) async {
    try {
      final verifiedUser = await loginDataSource.resendOTP(email);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
