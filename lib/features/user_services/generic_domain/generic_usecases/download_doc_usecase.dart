import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';

class ServiceDownloadDocument implements UseCase<int, Map<String, dynamic>> {
  final GenericUserServicesRepository repository;

  ServiceDownloadDocument(this.repository);

  @override
  Future<Either<Failure, int>> call(Map<String, dynamic> params) async {
    return await repository.downloadDocs(
        body: params['body'], urlParameters: params['paramerters']);
  }
}
