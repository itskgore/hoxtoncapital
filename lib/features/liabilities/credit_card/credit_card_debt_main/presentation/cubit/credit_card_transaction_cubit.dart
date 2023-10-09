import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/error/failures.dart';
import '../../data/model/credit_card_transaction_model.dart';
import '../../domain/repository/credit_card_repository.dart';
import 'credit_card_transaction_state.dart';

class CreditCardTransactionCubit extends Cubit<CreditCardTransactionState> {
  final GetCreditCardTransaction getCreditCardTransaction;
  late CardAndCashTransactionModel transactionDate;

  CreditCardTransactionCubit({
    required this.getCreditCardTransaction,
  }) : super(CreditCardTransactionInitial());

  getCreditCardTransactionData(
      {required String source,
      required String date,
      required String page,
      required String aggregatorAccountId}) {
    emit(CreditCardTransactionLoading());
    final result = getCreditCardTransaction({
      "source": source,
      'date': date,
      "page": page,
      "aggregatorAccountId": aggregatorAccountId,
    });

    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCreditCardTransactionData(
              source: source,
              date: date,
              page: page,
              aggregatorAccountId: aggregatorAccountId);
        } else {
          emit(CreditCardTransactionError(l.displayErrorMessage()));
        }
      }, (r) {
        transactionDate = r;

        emit(CreditCardTransactionLoaded(r));
      });
    });
  }
}
