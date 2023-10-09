import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_assets.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/custom_assets/add_custom_assets/domain/repositories/add_custom_assets_repository.dart';

import 'add_custom_assets_usecase.dart';

class UpdateCustomAssets
    implements UseCase<OtherAssetsEntity, CustomAssetsParams> {
  final AddCustomAssetsRepository repository;

  UpdateCustomAssets(this.repository);

  @override
  Future<Either<Failure, OtherAssetsEntity>> call(
      CustomAssetsParams params) async {
    return await repository.updateCustomAssets(
        params.name, params.country, params.type, params.value, params.id);
  }
}
