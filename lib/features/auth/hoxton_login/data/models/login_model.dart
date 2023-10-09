import 'package:wedge/features/auth/hoxton_login/domain/entities/login_entity.dart';

class LoginModel extends LoginUserEntity {
  LoginModel(
      {required String accessToken,
      required String refreshToken,
      required bool isOnboardingCompleted,
      bool? isMpineEnabled,
      bool? isTermsAndConditionsAccepted,
      required bool isProfileCompleted,
      bool? enableOTP,
      required dynamic lastLogin})
      : super(
            enableOTP: enableOTP ?? false,
            isProfileCompleted: isProfileCompleted,
            accessToken: accessToken,
            refreshToken: refreshToken,
            isMpineEnabled: isMpineEnabled ?? false,
            isOnboardingCompleted: isOnboardingCompleted,
            isTermsAndConditionsAccepted: isTermsAndConditionsAccepted ?? true,
            lastLogin: lastLogin);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        // enableOTP: json['enableOTP'] ?? true,
        enableOTP: false,
        isProfileCompleted: json['isProfileCompleted'] ?? true,
        accessToken: json['accessToken'] ?? "",
        isMpineEnabled:
            json['isMpinEnabled'] ?? json['isMpineEnabled'] ?? false,
        refreshToken: json['refreshToken'] ?? "",
        isOnboardingCompleted: json['isOnboardingCompleted'] ?? false,
        isTermsAndConditionsAccepted:
            json['isTermsAndConditionsAccepted'] ?? true,
        lastLogin: json['lastLogin'] ?? DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessToken'] = accessToken;
    data['enableOTP'] = enableOTP;
    data['isProfileCompleted'] = isProfileCompleted;
    data['refreshToken'] = refreshToken;
    data['isMpineEnabled'] = isMpineEnabled;
    data['isOnboardingCompleted'] = isOnboardingCompleted;
    data['isTermsAndConditionsAccepted'] = isTermsAndConditionsAccepted;
    data['lastLogin'] = lastLogin;
    return data;
  }
}
