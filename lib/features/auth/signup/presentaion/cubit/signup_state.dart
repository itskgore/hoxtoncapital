abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpError extends SignUpState {
  final String errorMsg;

  SignUpError(this.errorMsg);
}

class SignUpLoaded extends SignUpState {
  final dynamic signUpModel;

  SignUpLoaded({required this.signUpModel});
}
