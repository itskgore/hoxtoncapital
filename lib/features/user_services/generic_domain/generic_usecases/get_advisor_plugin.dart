import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';

class GetUserAdvisorUsecase
    extends UseCase<List<Map<String, dynamic>>, Map<String, dynamic>> {
  final GenericUserServicesRepository repository;

  GetUserAdvisorUsecase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(
      Map<String, dynamic> params) {
    return repository.getAdvisor(params['body'], params['paramerters']);
  }
}
