import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/domain/repositories/main_pension_investment_repository.dart';

class GetMainPensionInvestmentsInsights implements UseCase<dynamic, NoParams> {
  final MainPensionInvestmentRepository repository;

  GetMainPensionInvestmentsInsights(this.repository);

  @override
  Future<Either<Failure, dynamic>> call(NoParams params) async {
    return await repository.getInsights();
  }
}
