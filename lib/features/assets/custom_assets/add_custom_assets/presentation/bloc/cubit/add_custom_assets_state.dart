part of 'add_manual_bank_cubit.dart';

@immutable
abstract class AddCustomAssetsState {}

class AddCustomAssetsLoading extends AddCustomAssetsState {}

class AddCustomAssetsGetAssetsDropDownLoading extends AddCustomAssetsState {}

class AddCustomAssetsGetAssetsDropDownLoaded extends AddCustomAssetsState {
  final List<dynamic> data;

  AddCustomAssetsGetAssetsDropDownLoaded({required this.data});
}

class AddCustomAssetsGetAssetsDropDownError extends AddCustomAssetsState {
  final String errorMsg;

  AddCustomAssetsGetAssetsDropDownError({required this.errorMsg});
}

class AddCustomAssetsInitial extends AddCustomAssetsState {
  final status;
  final message;
  final data;

  AddCustomAssetsInitial(
      {required this.status, required this.message, required this.data});
}
