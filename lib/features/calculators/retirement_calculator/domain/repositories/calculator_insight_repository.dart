import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/insights_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CalculatorInsightsRepository {
  Future<Either<Failure, InsightsEntity?>> getInsights();
}
