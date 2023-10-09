part of 'home_bank_accounts_cubit.dart';

@immutable
abstract class HomeBankAccountsState {}

class HomeBankAccountsInitial extends HomeBankAccountsState {}

class HomeBankAccountsLoading extends HomeBankAccountsState {}

class HomeBankAccountsLoaded extends HomeBankAccountsState {
  final AssetsEntity data;
  bool? transactionUpdated;

  HomeBankAccountsLoaded({required this.data, this.transactionUpdated});
}

class HomeBankAccountsError extends HomeBankAccountsState {
  final String errorMsg;

  HomeBankAccountsError(this.errorMsg);
}
