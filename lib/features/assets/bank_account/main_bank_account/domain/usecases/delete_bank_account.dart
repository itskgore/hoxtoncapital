import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/domain/repositories/get_bank_accounts_repository.dart';

class DeleteBankAccounts
    implements UseCase<ManualBankAccountsEntity, DeleteParams> {
  final MainBankAccountsRepository repository;

  DeleteBankAccounts(this.repository);

  @override
  Future<Either<Failure, ManualBankAccountsEntity>> call(
      DeleteParams params) async {
    return await repository.deleteBankAccount(params.id);
  }
}
