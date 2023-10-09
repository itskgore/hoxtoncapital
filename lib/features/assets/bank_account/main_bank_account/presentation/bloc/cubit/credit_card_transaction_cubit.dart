import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/error/failures.dart';
import '../../../../../../liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';
import '../../../domain/repositories/get_bank_accounts_repository.dart';
import 'credit_card_transaction_state.dart';

class CashAccountTransactionCubit extends Cubit<CashAccountTransactionState> {
  final GetCashAccountTransaction getCashAccountTransaction;
  late CardAndCashTransactionModel transactionDate;

  CashAccountTransactionCubit({
    required this.getCashAccountTransaction,
  }) : super(CashAccountTransactionInitial());

  getCashAccountTransactionData(
      {required String source,
      required String date,
      required String page,
      required String aggregatorAccountId}) {
    emit(CashAccountTransactionLoading());
    final result = getCashAccountTransaction({
      "source": source,
      'date': date,
      "page": page,
      "aggregatorAccountId": aggregatorAccountId,
    });

    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getCashAccountTransactionData(
              source: source,
              date: date,
              page: page,
              aggregatorAccountId: aggregatorAccountId);
        } else {
          emit(CashAccountTransactionError(l.displayErrorMessage()));
        }
      }, (r) {
        transactionDate = r;

        emit(CashAccountTransactionLoaded(r));
      });
    });
  }
}
