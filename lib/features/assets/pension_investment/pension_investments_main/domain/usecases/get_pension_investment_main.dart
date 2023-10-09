import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/domain/repositories/main_pension_investment_repository.dart';

class GetMainPensionInvestments implements UseCase<AssetsEntity, NoParams> {
  final MainPensionInvestmentRepository repository;

  GetMainPensionInvestments(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getHoxtonDataSummery();
  }
}
