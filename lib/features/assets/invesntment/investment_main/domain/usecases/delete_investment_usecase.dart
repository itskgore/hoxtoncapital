import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/repositories/investments_repository.dart';

class DeleteInvestment implements UseCase<InvestmentEntity, DeleteParams> {
  final InvestmentRepository repository;

  DeleteInvestment(this.repository);

  @override
  Future<Either<Failure, InvestmentEntity>> call(DeleteParams params) async {
    return await repository.deleteInvestment(params.id);
  }
}
