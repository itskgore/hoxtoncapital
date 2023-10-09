import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/repositories/properties_repository.dart';

class DeleteProperties implements UseCase<PropertyEntity, DeleteParams> {
  final PropertiesRepository repository;

  DeleteProperties(this.repository);

  @override
  Future<Either<Failure, PropertyEntity>> call(DeleteParams params) async {
    return await repository.deleteProperties(params.id);
  }
}
