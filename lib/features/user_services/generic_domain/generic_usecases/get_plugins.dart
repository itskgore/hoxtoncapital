import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/user_services_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/user_services/generic_domain/generic_repository/user_services_repository.dart';

class GetPlugins extends UseCase<UserServicesEntity, NoParams> {
  final GenericUserServicesRepository repository;

  GetPlugins(this.repository);

  @override
  Future<Either<Failure, UserServicesEntity>> call(NoParams params) {
    return repository.getAllPlugins();
  }
}
