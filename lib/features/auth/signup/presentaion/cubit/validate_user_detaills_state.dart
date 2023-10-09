abstract class ValidateUserDetailsState {}

class ValidateUserDetailsInitial extends ValidateUserDetailsState {}

class ValidateUserDetailsLoading extends ValidateUserDetailsState {}

class ValidateUserDetailsError extends ValidateUserDetailsState {
  final String errorMsg;

  ValidateUserDetailsError(this.errorMsg);
}

class ValidateUserDetailsLoaded extends ValidateUserDetailsState {
  final dynamic validateUserDetailsModel;

  ValidateUserDetailsLoaded({required this.validateUserDetailsModel});
}
