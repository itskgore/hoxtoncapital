import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/home/domain/repository/dashboard_repo.dart';

class GetDashboardData extends UseCase<DashboardDataEntity, NoParams> {
  final DashboardDataRepo dashboardDataRepo;

  GetDashboardData(this.dashboardDataRepo);

  @override
  Future<Either<Failure, DashboardDataEntity>> call(NoParams params) {
    return dashboardDataRepo.getDashboardData();
  }
}
