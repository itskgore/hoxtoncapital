import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/insights_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/calculators/retirement_calculator/domain/repositories/calculator_insight_repository.dart';

class GetCalculatorInsights implements UseCase<InsightsEntity?, NoParams> {
  final CalculatorInsightsRepository repository;

  GetCalculatorInsights(this.repository);

  @override
  Future<Either<Failure, InsightsEntity?>> call(NoParams params) async {
    return await repository.getInsights();
  }
}
