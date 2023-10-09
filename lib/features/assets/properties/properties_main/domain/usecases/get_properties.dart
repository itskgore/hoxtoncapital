import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/repositories/properties_repository.dart';

class GetProperties implements UseCase<AssetsEntity, NoParams> {
  final PropertiesRepository repository;

  GetProperties(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getProperties();
  }
}
