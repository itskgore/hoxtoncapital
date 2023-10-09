import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/manual_bank_transactions_entity.dart';
import 'package:wedge/core/entities/yodlee_bank_transaction_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/data/data_sources/local_get_home_bankaccounts_source.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/data/data_sources/remote_bank_accounts_data_source.dart.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';

class GetHomeBankAccountsRepositoryImpl
    implements GetHomeBankAccountsRepository {
  final LocalHomeBankAccountsDataSource localDataSource;
  final RemoteHomeBankAccountDataSource remoteBankAccountDataSource;

  GetHomeBankAccountsRepositoryImpl(
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
  Future<Either<Failure, List<YodleeBankTransactionEntity>>>
      getYodleeBankTransactions(Map<String, dynamic> body) async {
    // TODO: implement getYodleeBankTransactions
    try {
      final result =
          await remoteBankAccountDataSource.getYodleeBankTransactions(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<ManualBankTransactionEntity>>>
      getManualBankTransactions(Map<String, dynamic> body) async {
    try {
      final result =
          await remoteBankAccountDataSource.getManualBankTransactions(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> updateManualBankBalanceSheet(
      Map<String, dynamic> body) async {
    try {
      final result =
          await remoteBankAccountDataSource.updateManualBankBalanceSheet(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> refreshAgreegatorAccount(
      Map<String, dynamic> body) async {
    try {
      final result =
          await remoteBankAccountDataSource.refreshAggregatorAccount(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
