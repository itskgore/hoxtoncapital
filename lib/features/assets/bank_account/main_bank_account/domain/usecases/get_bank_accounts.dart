import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/main_bank_account/domain/repositories/get_bank_accounts_repository.dart';

class GetBankAccounts implements UseCase<AssetsEntity, NoParams> {
  final MainBankAccountsRepository repository;

  GetBankAccounts(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getBankAccounts();
  }
}
