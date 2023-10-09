part of 'user_account_cubit.dart';

@immutable
abstract class UserAccountState {}

class UserAccountInitial extends UserAccountState {}

class UserAccountLoaded extends UserAccountState {
  final UserAccountDataEntity userAccountDataEntity;
  final bool isUpdated;
  String? errorMsg;

  UserAccountLoaded(
      {required this.userAccountDataEntity,
      required this.isUpdated,
      this.errorMsg});
}

class UserAccountLoading extends UserAccountState {}

class UserAccountError extends UserAccountState {
  final String errorMsg;

  UserAccountError({required this.errorMsg});
}
