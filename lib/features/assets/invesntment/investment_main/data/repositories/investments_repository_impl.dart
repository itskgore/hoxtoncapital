import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/invesntment/investment_main/data/data_sources/local_get_investments_source.dart';
import 'package:wedge/features/assets/invesntment/investment_main/data/data_sources/remote_investments_data_source.dart';
import 'package:wedge/features/assets/invesntment/investment_main/domain/repositories/investments_repository.dart';

class InvestmentsRepositoryImpl implements InvestmentRepository {
  final LocalInvestmentsDataSource localDataSource;
  final RemoteInvestmentsSource remoteStocksDataSource;

  InvestmentsRepositoryImpl(
      {required this.localDataSource, required this.remoteStocksDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getInvestments() async {
    try {
      final result = await localDataSource.getInvestments();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, InvestmentEntity>> deleteInvestment(String id) async {
    try {
      final result = await remoteStocksDataSource.deleteInvestment(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
