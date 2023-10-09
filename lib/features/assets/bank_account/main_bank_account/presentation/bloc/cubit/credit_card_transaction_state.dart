import '../../../../../../liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';

abstract class CashAccountTransactionState {}

class CashAccountTransactionInitial extends CashAccountTransactionState {}

class CashAccountTransactionLoading extends CashAccountTransactionState {}

class CashAccountTransactionError extends CashAccountTransactionState {
  final String errorMsg;

  CashAccountTransactionError(this.errorMsg);
}

class CashAccountTransactionLoaded extends CashAccountTransactionState {
  final CardAndCashTransactionModel cashAccountTransactionModel;
  final bool? showDeleteSnack;

  CashAccountTransactionLoaded(this.cashAccountTransactionModel,
      {this.showDeleteSnack});
}

class CashAccountTransactionDownload extends CashAccountTransactionState {
  final dynamic cashAccountTransactionDownload;

  CashAccountTransactionDownload(this.cashAccountTransactionDownload);
}
