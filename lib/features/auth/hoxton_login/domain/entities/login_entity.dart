import 'package:equatable/equatable.dart';

class LoginUserEntity extends Equatable {
  final String accessToken;
  final String refreshToken;
  bool isOnboardingCompleted;
  bool isMpineEnabled;
  bool isTermsAndConditionsAccepted;
  bool isProfileCompleted;
  bool enableOTP;
  final dynamic lastLogin;

  LoginUserEntity(
      {required this.accessToken,
      required this.isOnboardingCompleted,
      required this.isTermsAndConditionsAccepted,
      required this.isMpineEnabled,
      required this.enableOTP,
      required this.isProfileCompleted,
      required this.refreshToken,
      required this.lastLogin});

  @override
  List<Object> get props => [
        accessToken,
        isOnboardingCompleted,
        isMpineEnabled,
        enableOTP,
        isProfileCompleted,
        lastLogin,
        refreshToken,
        isTermsAndConditionsAccepted
      ];
}
