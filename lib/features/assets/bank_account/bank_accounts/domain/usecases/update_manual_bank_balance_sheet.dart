import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';

class UpdateManualBalanceSheet implements UseCase<bool, Map<String, dynamic>> {
  final GetHomeBankAccountsRepository repository;

  UpdateManualBalanceSheet(this.repository);

  @override
  Future<Either<Failure, bool>> call(Map<String, dynamic> params) async {
    return await repository.updateManualBankBalanceSheet(params);
  }
}
