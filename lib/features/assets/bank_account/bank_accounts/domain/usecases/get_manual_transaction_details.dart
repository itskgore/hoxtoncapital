import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/manual_bank_transactions_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';

class GetManualBankTransaction
    implements
        UseCase<List<ManualBankTransactionEntity>, Map<String, dynamic>> {
  final GetHomeBankAccountsRepository repository;

  GetManualBankTransaction(this.repository);

  @override
  Future<Either<Failure, List<ManualBankTransactionEntity>>> call(
      Map<String, dynamic> params) async {
    return await repository.getManualBankTransactions(params);
  }
}
