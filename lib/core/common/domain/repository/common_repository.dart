import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CommonRepository {
  Future<Either<Failure, Map<String, dynamic>>> refreshAgreegatorAccount(
      Map<String, dynamic> body);
  Future<Either<Failure, List<Map<String, dynamic>>>> excelDownload(
      Map<String, dynamic> body);
  Future<Either<Failure, dynamic>> getNotificationAndBanner();
  Future<Either<Failure, Map<String, dynamic>>> updateNotificationAndBanner(
      List<Map<String, dynamic>> body);
}
