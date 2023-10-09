import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/assets_liablities_main/domain/repositories/get_all_assets_repository.dart';

import '../../data/Models/assets_liabilities_model.dart';

class GetAllAssetsLiabilitiesMain
    implements UseCase<AssetsLiabilitiesModel, NoParams> {
  final GetAllAssetsLiabilitiesRepository repository;

  GetAllAssetsLiabilitiesMain(this.repository);

  @override
  Future<Either<Failure, AssetsLiabilitiesModel>> call(NoParams params) async {
    return await repository.getAssetsLiabilities();
  }
}
