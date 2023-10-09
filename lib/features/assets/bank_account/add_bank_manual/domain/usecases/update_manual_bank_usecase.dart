import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/manual_bank_accounts_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/add_bank_manual/domain/repositories/add_manualbank_repository.dart';

import 'add_manual_bank_usecase.dart';

class UpdateManualBankAccount
    implements UseCase<ManualBankAccountsEntity, ManualBankAccountsParams> {
  final AddManualBankRepository repository;

  UpdateManualBankAccount(this.repository);

  @override
  Future<Either<Failure, ManualBankAccountsEntity>> call(
      ManualBankAccountsParams params) async {
    return await repository.updateManualBank(params.name, params.country,
        params.currency, params.currentAmount, params.id);
  }
}
