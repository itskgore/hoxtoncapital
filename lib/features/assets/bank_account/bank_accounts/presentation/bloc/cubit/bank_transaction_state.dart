part of 'bank_transaction_cubit.dart';

@immutable
abstract class BankTransactionState {}

class BankTransactionInitial extends BankTransactionState {}

class BankTransactionLoading extends BankTransactionState {}

class BankTransactionLoaded extends BankTransactionState {
  List<YodleeBankTransactionEntity> yodleeTransactionsData;
  List<ManualBankTransactionEntity> manualTransactionData;
  bool? isUpdated;
  bool? didPageUpdate;
  Map<String, dynamic>? reconnectRes;

  BankTransactionLoaded(
      {required this.yodleeTransactionsData,
      required this.manualTransactionData,
      this.didPageUpdate,
      this.reconnectRes,
      this.isUpdated});
}

class BankTransactionError extends BankTransactionState {
  final String message;

  BankTransactionError(this.message);
}
