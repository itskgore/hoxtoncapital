import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/home/data/data_source/remote_dashboard_datasource.dart';
import 'package:wedge/features/home/domain/repository/dashboard_repo.dart';

class DashboardDataRepoImp extends DashboardDataRepo {
  final DashboardDataSource dashboardDataSource;

  DashboardDataRepoImp({required this.dashboardDataSource});

  @override
  Future<Either<Failure, DashboardDataEntity>> getDashboardData() async {
    try {
      final result = await dashboardDataSource.getDashBoardData();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
