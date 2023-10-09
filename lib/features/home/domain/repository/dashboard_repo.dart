import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class DashboardDataRepo {
  Future<Either<Failure, DashboardDataEntity>> getDashboardData();
}
