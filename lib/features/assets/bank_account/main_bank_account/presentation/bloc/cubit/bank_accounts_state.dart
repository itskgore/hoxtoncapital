part of 'bank_accounts_cubit.dart';

@immutable
abstract class BankAccountsState {}

class BankAccountsInitial extends BankAccountsState {}

class BankAccountsLoading extends BankAccountsState {}

class ShowPopup extends BankAccountsState {}

class BankAccountsLoaded extends BankAccountsState {
  final AssetsEntity assets;
  final bool deleteMessageSent;

  BankAccountsLoaded({required this.assets, required this.deleteMessageSent});
}

class BankAccountsError extends BankAccountsState {
  final String errorMsg;

  BankAccountsError(this.errorMsg);
}
