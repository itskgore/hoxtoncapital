import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/properties/properties_main/domain/repositories/properties_repository.dart';

class UnlinkProperties implements UseCase<bool, UnlinkParams> {
  final PropertiesRepository repository;

  UnlinkProperties(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnlinkParams params) async {
    return await repository.unlinkProperties(params);
  }
}
