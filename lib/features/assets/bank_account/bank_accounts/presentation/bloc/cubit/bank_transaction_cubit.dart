import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/manual_bank_transactions_entity.dart';
import 'package:wedge/core/entities/yodlee_bank_transaction_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/usecases/get_manual_transaction_details.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/usecases/get_transaction_details.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/usecases/refresh_aggregator_account.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/usecases/update_manual_bank_balance_sheet.dart';

part 'bank_transaction_state.dart';

class BankTransactionCubit extends Cubit<BankTransactionState> {
  GetYodleeBankTransaction getYodleeBankTransaction;
  GetManualBankTransaction getManualBankTransaction;
  UpdateManualBalanceSheet updateManualBalanceSheet;
  RefreshAggregatorAccount refreshAggregatorAccount;

  BankTransactionCubit(
      {required this.getManualBankTransaction,
      required this.updateManualBalanceSheet,
      required this.refreshAggregatorAccount,
      required this.getYodleeBankTransaction})
      : super(BankTransactionInitial());

  late List<YodleeBankTransactionEntity> listYodleeData = [];
  late List<ManualBankTransactionEntity> listManualData = [];

  getYodleeTransactions(
    Map<String, dynamic> body,
  ) {
    final result = getYodleeBankTransaction(body);
    if (body['page'] == "1") {
      emit(BankTransactionLoading());
    }
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getYodleeTransactions(body);
        } else {
          emit(BankTransactionError(l.displayErrorMessage()));
        }
      }, (r) {
        if (body['page'] != "1") {
          listYodleeData.addAll(r);
          emit(BankTransactionLoaded(
              didPageUpdate: r.isNotEmpty,
              manualTransactionData: listManualData,
              yodleeTransactionsData: listYodleeData));
        } else {
          listYodleeData = r;
          emit(BankTransactionLoaded(
              manualTransactionData: listManualData,
              yodleeTransactionsData: r));
        }
      });
    });
  }

  getManualTransactions(Map<String, dynamic> body, bool isUpdated) {
    if (!isUpdated) {
      emit(BankTransactionLoading());
    }

    final result = getManualBankTransaction(body);
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          getManualTransactions(body, isUpdated);
        } else {
          emit(BankTransactionError(l.displayErrorMessage()));
        }
      }, (r) {
        listManualData = r;
        emit(BankTransactionLoaded(
            isUpdated: isUpdated,
            manualTransactionData: r,
            yodleeTransactionsData: listYodleeData));
      });
    });
  }

  updateManualBankTransaction(
      Map<String, dynamic> body, ManualBankAccountsEntity data) {
    emit(BankTransactionLoading());
    final result = updateManualBalanceSheet(body);
    result.then((value) {
      value.fold((l) {
        if (l is BankCashReplicatedFailure) {
          emit(BankTransactionError(l.displayErrorMessage()));
          getManualTransactions({
            "bankAccountId": data.id,
            "date": "${DateTime.now().year}-${DateTime.now().month}",
            "page": "1"
          }, true);
        } else if (l is TokenExpired) {
          updateManualBankTransaction(body, data);
        } else {
          emit(BankTransactionError(l.displayErrorMessage()));
          getManualTransactions({
            "bankAccountId": data.id,
            "date": "${DateTime.now().year}-${DateTime.now().month}",
            "page": "1"
          }, true);
          return;
        }
      }, (r) {
        getManualTransactions({
          "bankAccountId": data.id,
          "date": "${DateTime.now().year}-${DateTime.now().month}",
          "page": "1"
        }, true);
        // emit(BankTransactionLoaded(
        //     manualTransactionData: listManualData,
        //     yoddleTransactionsData: listYoddleData,
        //     isUpdated: true));
      });
    });
  }

  refreshSaltedgeAccount(ManualBankAccountsEntity data) {
    final result = refreshAggregatorAccount({
      "connectionId": "${data.aggregator!.connectionId}",
      "customerId": "${data.aggregator!.customerId}",
      "institutionId": "${data.aggregator!.institutionId}",
      "returnTo": "https://www.getwedge.com",
      "provider": "saltedge"
    });
    result.then((value) {
      value.fold((l) {
        if (l is TokenExpired) {
          refreshSaltedgeAccount(data);
        } else {
          emit(BankTransactionError(l.displayErrorMessage()));
          getManualTransactions({
            "bankAccountId": data.id,
            "date": "${DateTime.now().year}-${DateTime.now().month}",
            "page": "1"
          }, true);
        }
      }, (r) {
        emit(BankTransactionLoaded(
            yodleeTransactionsData: listYodleeData,
            manualTransactionData: listManualData,
            reconnectRes: r));
        // getManualTransactions({
        //   "bankAccountId": data.id,
        //   "date": "${DateTime.now().year}-${DateTime.now().month}",
        //   "page": "1"
        // }, false);
      });
    });
  }
}
