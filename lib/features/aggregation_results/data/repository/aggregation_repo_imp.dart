import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/asset_liabilities_charts_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/aggregation_results/data/datasource/local_results.dart';
import 'package:wedge/features/aggregation_results/data/datasource/remote_results.dart';
import 'package:wedge/features/aggregation_results/domain/repository/aggregation_repo.dart';

class AggregationResultRepoImp extends AggregationResultRepo {
  LocalAggregationResults localAggregationResults;
  RemoteAggregationResults remoteAggregationResults;

  AggregationResultRepoImp(
      {required this.localAggregationResults,
      required this.remoteAggregationResults});

  @override
  Future<Either<Failure, AssetLiabilitiesChartEntity>> getAggregationResult(
      List<String> years) async {
    try {
      final data = await remoteAggregationResults.getAggregationResult(years);
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
