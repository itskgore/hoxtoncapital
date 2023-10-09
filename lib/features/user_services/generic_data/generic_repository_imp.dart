import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_report_entity.dart';
import 'package:wedge/core/entities/user_services_document_entity.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/user_services/generic_data/generic_remote_datasource.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';

class GenericUserServicesRepositoryImp extends GenericUserServicesRepository {
  final GenericServicesDataSource dashboardDataSource;

  GenericUserServicesRepositoryImp({required this.dashboardDataSource});

  @override
  Future<Either<Failure, UserServicesEntity>> getAllPlugins() async {
    try {
      final result = await dashboardDataSource.getAllPlugins();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAdvisor(
      Map<String, dynamic> body, String urlParameters) async {
    try {
      final result = await dashboardDataSource.getAdvisors(body, urlParameters);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, UserDocumentRecordsEntity>> getDocuments(
      Map<String, dynamic> body, String urlParameters) async {
    try {
      final result =
          await dashboardDataSource.getDocuments(body, urlParameters);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, int>> downloadDocs(
      {Map<String, dynamic>? body, String? urlParameters}) async {
    try {
      final result = await dashboardDataSource.downloadDocuments(
          body: body, urlParameters: urlParameters);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, PensionReportEntity>> getPensionReports(
      String urlParameters) async {
    // TODO: implement getPensionReports
    try {
      final result = await dashboardDataSource.getPensionReport(urlParameters);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
