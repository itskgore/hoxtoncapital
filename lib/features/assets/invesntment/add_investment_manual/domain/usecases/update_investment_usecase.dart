import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/domain/repositories/add_investment_repository.dart';

import 'add_investment_usecase.dart';

class UpdateInvestment implements UseCase<InvestmentEntity, InvestmentParams> {
  final AddInvestmentRepository repository;

  UpdateInvestment(this.repository);

  @override
  Future<Either<Failure, InvestmentEntity>> call(
      InvestmentParams params) async {
    return await repository.updateInvestment(
        params.id,
        params.name,
        params.country,
        params.policyNumber,
        params.initialValue,
        params.currentValue);
  }
}
