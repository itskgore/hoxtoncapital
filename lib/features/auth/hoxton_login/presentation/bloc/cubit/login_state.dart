part of 'login_cubit.dart';

@immutable
abstract class LoginState {
}

class LoginInitial extends LoginState {
  final dynamic loginSuccess;
  final bool isloading;
  final String errorMessage;
  final bool isEmailVerified;
  final bool isPasswordVerified;
  final LoginEmailEntity emailUserData;
  final LoginUserEntity loginUserData;
  final bool isForgotPasswordClicked;
  final bool isResetPasswordLinkSent;
  bool? isForceResetPassword;
  bool? isPasscodeLogin;
  bool? isOTPVerified;

  LoginInitial({
    required this.loginUserData,
    required this.errorMessage,
    this.isForceResetPassword,
    this.isPasscodeLogin,
    this.isOTPVerified,
    required this.isEmailVerified,
    required this.isPasswordVerified,
    required this.emailUserData,
    required this.isloading,
    required this.isForgotPasswordClicked,
    required this.isResetPasswordLinkSent,
    required this.loginSuccess,
  });
}
