import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/repositories/investments_repository.dart';

class GetInvestments implements UseCase<AssetsEntity, NoParams> {
  final InvestmentRepository repository;

  GetInvestments(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getInvestments();
  }
}
