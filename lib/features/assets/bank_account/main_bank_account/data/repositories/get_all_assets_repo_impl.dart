import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/data/data_sources/local_get_bankaccounts_source.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/data/data_sources/remote_bank_accounts_data_source.dart.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/domain/repositories/get_bank_accounts_repository.dart';

import '../../../../../liabilities/credit_card/credit_card_debt_main/data/model/credit_card_transaction_model.dart';
import '../model/cash_account_pie_performance_model.dart';

class GetBankAccountsRepositoryImpl implements MainBankAccountsRepository {
  final LocalBankAccountsDataSource localDataSource;
  final RemoteBankAccountDataSource remoteBankAccountDataSource;

  GetBankAccountsRepositoryImpl(
      {required this.localDataSource,
      required this.remoteBankAccountDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getBankAccounts() async {
    try {
      final result = await localDataSource.getBankAccounts();
      return Right(result);
    } on CacheFailure {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ManualBankAccountsEntity>> deleteBankAccount(
      String id) async {
    try {
      final result = await remoteBankAccountDataSource.deleteBankAccount(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CardAndCashTransactionModel>>
      getCashAccountTransaction(
          {required String source,
          required String date,
          required String page,
          required String aggregatorAccountId}) async {
    try {
      final result = await remoteBankAccountDataSource
          .getCashAccountTransactions(source, date, page, aggregatorAccountId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<CashAccountPiePerformanceModel>>>
      getCashAccountPiePerformance(
          {required String month, required String aggregatorAccountId}) async {
    try {
      final result = await remoteBankAccountDataSource
          .getCashAccountPiePerformance(aggregatorAccountId, month);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getCashAccountBarPerformance() async {
    try {
      final result =
          await remoteBankAccountDataSource.getCashAccountBarPerformance();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
