part of 'support_account_cubit.dart';

@immutable
abstract class SupportAccountState {}

class SupportAccountInitial extends SupportAccountState {}

class SupportAccountLoading extends SupportAccountState {}

class SupportAccountLoaded extends SupportAccountState {
  final bool status;
  final String message;

  SupportAccountLoaded({required this.status, required this.message});
}

class SupportAccountError extends SupportAccountState {
  final String errorMsg;

  SupportAccountError({required this.errorMsg});
}
