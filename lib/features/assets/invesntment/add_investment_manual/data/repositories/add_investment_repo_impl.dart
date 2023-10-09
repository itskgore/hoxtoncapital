import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/data/data_sources/add_investment_data_source.dart';
import 'package:wedge/features/assets/invesntment/add_investment_manual/domain/repositories/add_investment_repository.dart';

class AddInvestmentRepositoryImpl implements AddInvestmentRepository {
  final AddInvestmentDataSource addInvestmentDataSource;

  AddInvestmentRepositoryImpl({required this.addInvestmentDataSource});

  @override
  Future<Either<Failure, InvestmentEntity>> addInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue) async {
    try {
      final data = await addInvestmentDataSource.addInvestment(
          id, name, country, policyNumber, initialValue, currentValue);
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, InvestmentEntity>> updateInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue) async {
    try {
      final verifiedUser = await addInvestmentDataSource.updateInvestment(
          id, name, country, policyNumber, initialValue, currentValue);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
