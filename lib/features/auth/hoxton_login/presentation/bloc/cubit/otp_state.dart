part of 'otp_cubit.dart';

abstract class OtpState extends Equatable {
  const OtpState();

  @override
  List<Object> get props => [];
}

class OtpInitial extends OtpState {
  final bool isValidationLoading;
  final bool isResendPasswordLoading;
  final LoginUserEntity loginuserData;
  final String errorMessage;
  final bool isresentCode;

  OtpInitial(
      {required this.isValidationLoading,
      required this.isResendPasswordLoading,
      required this.loginuserData,
      required this.errorMessage,
      required this.isresentCode});
}

class OtpLoading extends OtpState {}

class OtpError extends OtpState {
  final String errorMessage;

  OtpError({required this.errorMessage});
}

class OtpSuccess extends OtpState {
  final LoginUserEntity loginuserData;

  OtpSuccess({required this.loginuserData});
}
