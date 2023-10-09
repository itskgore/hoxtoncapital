import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/user_services_document_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';

class GetDocumentUsecase
    extends UseCase<UserDocumentRecordsEntity, Map<String, dynamic>> {
  final GenericUserServicesRepository repository;

  GetDocumentUsecase(this.repository);

  @override
  Future<Either<Failure, UserDocumentRecordsEntity>> call(
      Map<String, dynamic> params) {
    return repository.getDocuments(params['body'], params['paramerters']);
  }
}
