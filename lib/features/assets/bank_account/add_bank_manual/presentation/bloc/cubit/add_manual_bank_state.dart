part of 'add_manual_bank_cubit.dart';

@immutable
abstract class AddManualBankState {}

class AddManualBankLoading extends AddManualBankState {}

class AddManualBankInitial extends AddManualBankState {
  final status;
  final message;
  final data;

  AddManualBankInitial(
      {required this.status, required this.message, required this.data});
}
