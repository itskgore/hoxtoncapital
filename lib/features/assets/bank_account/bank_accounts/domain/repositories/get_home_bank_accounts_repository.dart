import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/entities/manual_bank_transactions_entity.dart';
import 'package:wedge/core/entities/yodlee_bank_transaction_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetHomeBankAccountsRepository {
  Future<Either<Failure, AssetsEntity>> getBankAccounts();

  Future<Either<Failure, ManualBankAccountsEntity>> deleteBankAccount(
      String id);

  Future<Either<Failure, List<YodleeBankTransactionEntity>>>
      getYodleeBankTransactions(Map<String, dynamic> body);

  Future<Either<Failure, List<ManualBankTransactionEntity>>>
      getManualBankTransactions(Map<String, dynamic> body);

  Future<Either<Failure, bool>> updateManualBankBalanceSheet(
      Map<String, dynamic> body);

  Future<Either<Failure, Map<String, dynamic>>> refreshAgreegatorAccount(
      Map<String, dynamic> body);
}
