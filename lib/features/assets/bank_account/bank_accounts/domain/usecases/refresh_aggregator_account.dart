import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/bank_accounts/domain/repositories/get_home_bank_accounts_repository.dart';

class RefreshAggregatorAccount
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final GetHomeBankAccountsRepository repository;

  RefreshAggregatorAccount(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) async {
    return await repository.refreshAgreegatorAccount(params);
  }
}
