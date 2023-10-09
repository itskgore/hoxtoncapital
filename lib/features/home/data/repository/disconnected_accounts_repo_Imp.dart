import 'package:dartz/dartz.dart';
import 'package:wedge/features/home/data/model/disconnected_account_entity.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repository/dissconnect_accounts_repo.dart';
import '../data_source/remote_dashboard_datasource.dart';

class DisconnectedAccountsRepoImp implements DisconnectedAccountsRepo {
  final DashboardDataSource dashboardDataSource;

  DisconnectedAccountsRepoImp({required this.dashboardDataSource});

  @override
  Future<Either<Failure, List<DisconnectedAccountsEntity>>>
      getDisconnectedAccountData() async {
    try {
      final result = await dashboardDataSource.getDisconnectedAccounts();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
