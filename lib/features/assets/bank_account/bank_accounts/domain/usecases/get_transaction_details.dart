import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/yodlee_bank_transaction_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';

class GetYodleeBankTransaction
    implements
        UseCase<List<YodleeBankTransactionEntity>, Map<String, dynamic>> {
  final GetHomeBankAccountsRepository repository;

  GetYodleeBankTransaction(this.repository);

  @override
  Future<Either<Failure, List<YodleeBankTransactionEntity>>> call(
      Map<String, dynamic> params) async {
    return await repository.getYodleeBankTransactions(params);
  }
}
