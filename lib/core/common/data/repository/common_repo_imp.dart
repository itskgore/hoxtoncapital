import 'package:wedge/core/common/data/datasource/common_datasource.dart';
import 'package:wedge/core/common/domain/repository/common_repository.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:dartz/dartz.dart';

class CommonRepositoryImp implements CommonRepository {
  final CommonDataSource commonDataSource;

  CommonRepositoryImp({required this.commonDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> refreshAgreegatorAccount(
      Map<String, dynamic> body) async {
    try {
      final result = await commonDataSource.refreshAgreegatorAccount(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> excelDownload(
      Map<String, dynamic> body) async {
    try {
      final result = await commonDataSource.excelDownload(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, dynamic>> getNotificationAndBanner() async {
    try {
      final result = await commonDataSource.getNotificationAndBanner();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> updateNotificationAndBanner(
      List<Map<String, dynamic>> body) async {
    try {
      final result = await commonDataSource.updateNotificationAndBanner(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
