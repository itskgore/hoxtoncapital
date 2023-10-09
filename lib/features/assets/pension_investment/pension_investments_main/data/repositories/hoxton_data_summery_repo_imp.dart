import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/data/data_sources/hoxton_userdata_source.dart';
import 'package:wedge/features/assets/pension_investment/pension_investments_main/domain/repositories/main_pension_investment_repository.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/verified_user_model.dart';

class MainPensionInvestmentRepositoryImpl
    implements MainPensionInvestmentRepository {
  final MainPensionInvestmentDataSource hoxtonUserDataSource;

  MainPensionInvestmentRepositoryImpl({required this.hoxtonUserDataSource});

  @override
  Future<Either<Failure, AssetsEntity>> getHoxtonDataSummery() async {
    try {
      final result = await hoxtonUserDataSource.getHoxtonDataSummery(); //change
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, VerifiedUser>> getUserDetails() async {
    try {
      final result = await hoxtonUserDataSource.getUserDetails(); //change
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, dynamic>> getInsights() async {
    try {
      final result = await hoxtonUserDataSource.getInsights(); //change
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
