import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/asset_liabilities_charts_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AggregationResultRepo {
  Future<Either<Failure, AssetLiabilitiesChartEntity>> getAggregationResult(
      List<String> years);
}
