import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/repository/main_pensions_repository.dart';

class GetPensionsUseCase implements UseCase<AssetsEntity, NoParams> {
  GetPensionsUseCase(this.repository);

  final MainPensionsRepository repository;

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getPensions();
  }
}
