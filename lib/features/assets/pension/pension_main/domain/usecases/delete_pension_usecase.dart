import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/pension/pension_main/domain/repository/main_pensions_repository.dart';

class DeletePensionUsecase implements UseCase<PensionsEntity, DeleteParams> {
  DeletePensionUsecase(this.repository);

  final MainPensionsRepository repository;

  @override
  Future<Either<Failure, PensionsEntity>> call(DeleteParams params) {
    return repository.deletePension(params.id);
  }
}
