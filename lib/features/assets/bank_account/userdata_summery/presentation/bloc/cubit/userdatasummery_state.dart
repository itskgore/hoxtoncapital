part of 'userdatasummery_cubit.dart';

@immutable
abstract class UserDataSummeryState {}

class UserDataSummeryInitial extends UserDataSummeryState {}

class UserDataSummeryLoading extends UserDataSummeryState {}

class UserDataSummeryLoaded extends UserDataSummeryState {
  final HoxtonUserDataSUmmeryEntity data;
  final String clientName;

  UserDataSummeryLoaded({required this.data, required this.clientName});
}

class UserDataSummeryError extends UserDataSummeryState {
  final String errorMsg;

  UserDataSummeryError(this.errorMsg);
}
