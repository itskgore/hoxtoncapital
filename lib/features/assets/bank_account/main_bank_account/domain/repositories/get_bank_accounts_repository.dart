import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../../core/usecases/usecase.dart';
import '../../../../../liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';
import '../../data/model/cash_account_pie_performance_model.dart';

abstract class MainBankAccountsRepository {
  Future<Either<Failure, AssetsEntity>> getBankAccounts();

  Future<Either<Failure, ManualBankAccountsEntity>> deleteBankAccount(
      String id);

  Future<Either<Failure, List<CashAccountPiePerformanceModel>>>
      getCashAccountPiePerformance(
          {required String month, required String aggregatorAccountId});

  Future<Either<Failure, List<dynamic>>> getCashAccountBarPerformance();

  Future<Either<Failure, CardAndCashTransactionModel>>
      getCashAccountTransaction(
          {required String source,
          required String date,
          required String page,
          required String aggregatorAccountId});
}

class GetCashAccountTransaction
    extends UseCase<CardAndCashTransactionModel, Map<String, dynamic>> {
  final MainBankAccountsRepository mainCashAccountRepo;

  GetCashAccountTransaction(this.mainCashAccountRepo);

  @override
  Future<Either<Failure, CardAndCashTransactionModel>> call(
      Map<String, dynamic> params) {
    return mainCashAccountRepo.getCashAccountTransaction(
        source: params['source'],
        date: params['date'],
        page: params['page'],
        aggregatorAccountId: params['aggregatorAccountId']);
  }
}

class GetCashAccountPiePerformance extends UseCase<
    List<CashAccountPiePerformanceModel>, Map<String, dynamic>> {
  final MainBankAccountsRepository mainCashAccountRepo;

  GetCashAccountPiePerformance(this.mainCashAccountRepo);

  @override
  Future<Either<Failure, List<CashAccountPiePerformanceModel>>> call(
      Map<String, dynamic> params) {
    return mainCashAccountRepo.getCashAccountPiePerformance(
      month: params['month'],
      aggregatorAccountId: params['aggregatorAccountId'],
    );
  }
}

class GetCashAccountBarPerformance
    extends UseCase<List<dynamic>, Map<String, dynamic>> {
  final MainBankAccountsRepository mainCashAccountRepo;

  GetCashAccountBarPerformance(this.mainCashAccountRepo);

  @override
  Future<Either<Failure, List<dynamic>>> call(Map<String, dynamic> params) {
    return mainCashAccountRepo.getCashAccountBarPerformance();
  }
}
