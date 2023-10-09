import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/repositories/get_all_assets_repository.dart';

class GetAllLiabilitiesMain implements UseCase<LiabilitiesEntity, NoParams> {
  final GetAllAssetsLiabilitiesRepository repository;

  GetAllLiabilitiesMain(this.repository);

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) async {
    return await repository.getLiabilities();
  }
}
