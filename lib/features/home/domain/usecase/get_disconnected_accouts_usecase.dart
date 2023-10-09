import 'package:dartz/dartz.dart';
import 'package:wedge/features/home/data/model/disconnected_account_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repository/dissconnect_accounts_repo.dart';

class GetDisconnectedAccountsUseCase
    extends UseCase<List<DisconnectedAccountsEntity>, NoParams> {
  final DisconnectedAccountsRepo disconnectAccountsDataRepo;

  GetDisconnectedAccountsUseCase(this.disconnectAccountsDataRepo);

  @override
  Future<Either<Failure, List<DisconnectedAccountsEntity>>> call(
      NoParams params) {
    return disconnectAccountsDataRepo.getDisconnectedAccountData();
  }
}
