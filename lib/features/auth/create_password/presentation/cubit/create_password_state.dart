part of 'create_password_cubit.dart';

@immutable
abstract class CreatePasswordState {}

class CreatePasswordInitial extends CreatePasswordState {}

class CreatePasswordLoading extends CreatePasswordState {}

class CreatePasswordLoaded extends CreatePasswordState {
  final int statusCode;

  CreatePasswordLoaded({required this.statusCode});
}

class CreatePasswordError extends CreatePasswordState {
  final String errorMsg;

  CreatePasswordError(this.errorMsg);
}
