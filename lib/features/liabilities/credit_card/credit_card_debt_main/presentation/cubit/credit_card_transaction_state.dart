import '../../data/model/credit_card_transaction_model.dart';

abstract class CreditCardTransactionState {}

class CreditCardTransactionInitial extends CreditCardTransactionState {}

class CreditCardTransactionLoading extends CreditCardTransactionState {}

class CreditCardTransactionError extends CreditCardTransactionState {
  final String errorMsg;

  CreditCardTransactionError(this.errorMsg);
}

class CreditCardTransactionLoaded extends CreditCardTransactionState {
  final CardAndCashTransactionModel creditCardTransactionModel;
  final bool? showDeleteSnack;

  CreditCardTransactionLoaded(this.creditCardTransactionModel,
      {this.showDeleteSnack});
}

class CreditCardTransactionDownload extends CreditCardTransactionState {
  final dynamic creditCardTransactionDownload;

  CreditCardTransactionDownload(this.creditCardTransactionDownload);
}
