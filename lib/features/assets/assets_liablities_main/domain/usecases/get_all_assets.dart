import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/repositories/get_all_assets_repository.dart';

class GetAllAssetsMain implements UseCase<AssetsEntity, NoParams> {
  final GetAllAssetsLiabilitiesRepository repository;

  GetAllAssetsMain(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getAssets();
  }
}
