part of 'change_password_cubit.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordLoaded extends ChangePasswordState {
  final dynamic data;

  ChangePasswordLoaded(this.data);
}

class ChangePasswordError extends ChangePasswordState {
  final String errorMsg;

  ChangePasswordError(this.errorMsg);
}
