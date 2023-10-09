import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/all_assets/domain/repositories/get_all_assets_repository.dart';

class GetAllAssets implements UseCase<AssetsEntity, NoParams> {
  final GetAllAssetsRepository repository;

  GetAllAssets(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getAssets();
  }
}
