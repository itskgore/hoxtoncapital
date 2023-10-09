import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/custom_assets_main/domain/repositories/custom_assets_repository.dart';

class GetCustomAssets implements UseCase<AssetsEntity, NoParams> {
  final CustomAssetsRepository repository;

  GetCustomAssets(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getCustomAssets();
  }
}
