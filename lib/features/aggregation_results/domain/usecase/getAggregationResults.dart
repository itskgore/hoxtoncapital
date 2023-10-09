import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/asset_liabilities_charts_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/aggregation_results/domain/repository/aggregation_repo.dart';

class GetAggregationResultUsecase
    extends UseCase<AssetLiabilitiesChartEntity, List<String>> {
  AggregationResultRepo aggregationResultRepo;

  GetAggregationResultUsecase(this.aggregationResultRepo);

  @override
  Future<Either<Failure, AssetLiabilitiesChartEntity>> call(
      List<String> params) {
    return aggregationResultRepo.getAggregationResult(params);
  }
}
