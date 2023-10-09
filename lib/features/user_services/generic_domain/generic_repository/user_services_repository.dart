import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_report_entity.dart';
import 'package:wedge/core/entities/user_services_document_entity.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GenericUserServicesRepository {
  Future<Either<Failure, UserServicesEntity>> getAllPlugins();

  Future<Either<Failure, List<Map<String, dynamic>>>> getAdvisor(
      Map<String, dynamic> body, String urlParameters);

  Future<Either<Failure, UserDocumentRecordsEntity>> getDocuments(
      Map<String, dynamic> body, String urlParameters);

  Future<Either<Failure, int>> downloadDocs(
      {Map<String, dynamic>? body, String? urlParameters});

  Future<Either<Failure, PensionReportEntity>> getPensionReports(
      String urlParameters);
}
