import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';

class VerifiedUser extends LoginEmailEntity {
  VerifiedUser(
      {required String firstName,
      required String lastName,
      required String email,
      required bool isTermsAndConditionsAccepted,
      required bool isForceResetPassword,
      required bool isOnboardingCompleted})
      : super(
            firstName: firstName,
            email: email,
            lastName: lastName,
            isForceResetPassword: isForceResetPassword,
            isTermsAndConditionsAccepted: isTermsAndConditionsAccepted,
            isOnboardingCompleted: isOnboardingCompleted);

  fromJson(Map<String, dynamic> json) {}

  factory VerifiedUser.fromJson(Map<String, dynamic> json) {
    return VerifiedUser(
        firstName: json['firstName'],
        lastName: json['lastName'],
        isForceResetPassword: json['isForceResetPassword'] ?? false,
        email: json['email'],
        isTermsAndConditionsAccepted: json['isTermsAndConditionsAccepted'],
        isOnboardingCompleted: json['isOnboardingCompleted'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['isForceResetPassword'] = this.isForceResetPassword;
    data['email'] = this.email;
    data['isTermsAndConditionsAccepted'] = this.isTermsAndConditionsAccepted;
    data['isOnboardingCompleted'] = this.isOnboardingCompleted;
    return data;
  }
}
