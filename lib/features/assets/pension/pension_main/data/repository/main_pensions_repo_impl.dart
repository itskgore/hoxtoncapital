import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/pension/pension_main/data/datasource/local_pensions_datasource.dart';
import 'package:wedge/features/assets/pension/pension_main/data/datasource/remote_pensions_datasource.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/repository/main_pensions_repository.dart';

class MainPensionsRepositoryImp implements MainPensionsRepository {
  MainPensionsRepositoryImp(
      {required this.localPensionsDataSource,
      required this.remotePensionsDataSource});

  final LocalPensionsDataSource localPensionsDataSource;
  final RemotePensionsDataSource remotePensionsDataSource;

  @override
  Future<Either<Failure, PensionsEntity>> deletePension(String id) async {
    try {
      final result = await remotePensionsDataSource.deletePension(id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, AssetsEntity>> getPensions() async {
    try {
      final result = await localPensionsDataSource.getPensions();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
