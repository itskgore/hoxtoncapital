import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_report_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';

class GetPensionReportUsecase extends UseCase<PensionReportEntity, String> {
  final GenericUserServicesRepository repository;

  GetPensionReportUsecase(this.repository);

  @override
  Future<Either<Failure, PensionReportEntity>> call(String urlParams) =>
      repository.getPensionReports(urlParams);
}
