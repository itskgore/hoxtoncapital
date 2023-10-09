part of 'forgotpassword_cubit.dart';

abstract class ForgotpasswordState extends Equatable {
  const ForgotpasswordState();

  @override
  List<Object> get props => [];
}

class ForgotpasswordInitial extends ForgotpasswordState {}

class ForgotpasswordLoading extends ForgotpasswordState {}

class ForgotpasswordLoaded extends ForgotpasswordState {
  final bool success;
  final String mail;

  ForgotpasswordLoaded(this.success, this.mail);
}

class ForgotpasswordError extends ForgotpasswordState {
  final String error;

  ForgotpasswordError(this.error);
}
