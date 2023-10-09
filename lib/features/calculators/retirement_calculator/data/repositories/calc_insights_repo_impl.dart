import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/insights_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/calculators/retirement_calculator/data/data_sources/get_calculator_insights_data_source.dart';
import 'package:wedge/features/calculators/retirement_calculator/domain/repositories/calculator_insight_repository.dart';

class CalculatorInsightsRepoImpl implements CalculatorInsightsRepository {
  final CalculatorInsightsDataSource dataSource;

  CalculatorInsightsRepoImpl({required this.dataSource});

  @override
  Future<Either<Failure, InsightsModel?>> getInsights() async {
    try {
      final response = await dataSource.getInsights();
      return Right(response);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
