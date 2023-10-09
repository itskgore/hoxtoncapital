part of 'add_manual_pension_cubit.dart';

@immutable
abstract class AddManualPensionState {}

class AddManualPensionInitial extends AddManualPensionState {
  bool changeType = false;
  String pensionType;
  bool isLoading = false;

  AddManualPensionInitial(
      {required this.changeType,
      required this.pensionType,
      required this.isLoading});
}

class AddManualPensionLoading extends AddManualPensionState {}

class AddManualPensionLoaded extends AddManualPensionState {
  final status;
  final message;
  final data;

  AddManualPensionLoaded({this.status, this.message, this.data});
}

class AddManualPensionError extends AddManualPensionState {
  final String errorMsg;

  AddManualPensionError({required this.errorMsg});
}
