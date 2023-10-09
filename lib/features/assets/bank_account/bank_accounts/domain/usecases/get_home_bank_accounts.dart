import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';

class GetHomeBankAccounts implements UseCase<AssetsEntity, NoParams> {
  final GetHomeBankAccountsRepository repository;

  GetHomeBankAccounts(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getBankAccounts();
  }
}
