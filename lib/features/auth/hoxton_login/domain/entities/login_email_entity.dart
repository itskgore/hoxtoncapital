import 'package:equatable/equatable.dart';

class LoginEmailEntity extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final bool isTermsAndConditionsAccepted;
  final bool isOnboardingCompleted;
  bool? isForceResetPassword = true;

  LoginEmailEntity({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.isTermsAndConditionsAccepted,
    required this.isOnboardingCompleted,
    this.isForceResetPassword,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        isTermsAndConditionsAccepted,
        isForceResetPassword ?? true,
        isOnboardingCompleted
      ];
}
