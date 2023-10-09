import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/domain/repositories/custom_assets_repository.dart';

class DeleteCustomAssets implements UseCase<OtherAssetsEntity, DeleteParams> {
  final CustomAssetsRepository repository;

  DeleteCustomAssets(this.repository);

  @override
  Future<Either<Failure, OtherAssetsEntity>> call(DeleteParams params) async {
    return await repository.deleteCustomAssets(params.id);
  }
}
