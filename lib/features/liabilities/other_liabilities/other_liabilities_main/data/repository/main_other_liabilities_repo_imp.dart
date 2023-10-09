import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/data/datasource/local_main_other_liabilities.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/data/datasource/remote_main_other_liabilities.dart';
import 'package:wedge/features/liabilities/other_liabilities/other_liabilities_main/domain/repository/main_other_liabilities_repo.dart';

class MainOtherRepositoryRepoImp implements MainOtherRepositoryRepo {
  MainOtherRepositoryRepoImp(
      {required this.localOtherLiabilitiesDatasource,
      required this.remoteOtherLiabilitiesDatasource});

  final LocalOtherLiabilitiesDatasource localOtherLiabilitiesDatasource;
  final RemoteOtherLiabilitiesDatasource remoteOtherLiabilitiesDatasource;

  @override
  Future<Either<Failure, OtherLiabilitiesEntity>> deleteOtherLiabilities(
      String id) async {
    try {
      final result =
          await remoteOtherLiabilitiesDatasource.deleteotherLiabilities(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LiabilitiesEntity>> getOtherLiabilities() async {
    try {
      final result =
          await localOtherLiabilitiesDatasource.getOtherLiabilitiesData();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
