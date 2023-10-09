import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginUserEntity>> login(
      String email, String password, bool isTermsAndConditionsAccepted);

  Future<Either<Failure, LoginUserEntity>> validateOTP(
      String email, String password);

  Future<Either<Failure, int>> resendCode(String email);

  Future<Either<Failure, dynamic>> loginWithOTP(
      String email, String password, bool isTermsAndConditionsAccepted,
      {String? passcode, bool? isOTPVerified});

  Future<Either<Failure, LoginEmailEntity>> verifyEmail(String email);

  Future<Either<Failure, bool>> resetPassword(String email);
}
