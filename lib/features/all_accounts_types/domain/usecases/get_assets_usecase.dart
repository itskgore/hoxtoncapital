import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/assets_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/all_accounts_types/domain/repositories/main_assets_liab_repo.dart';

class GetMainAssets implements UseCase<AssetsEntity, NoParams> {
  final AssetsLiabilitiesMainRepository repository;

  GetMainAssets(this.repository);

  @override
  Future<Either<Failure, AssetsEntity>> call(NoParams params) async {
    return await repository.getMainAssets();
  }
}
