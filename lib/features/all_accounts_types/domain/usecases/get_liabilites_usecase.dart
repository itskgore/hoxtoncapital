import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/all_accounts_types/domain/repositories/main_assets_liab_repo.dart';

class GetMainLiabilities implements UseCase<LiabilitiesEntity, NoParams> {
  final AssetsLiabilitiesMainRepository repository;

  GetMainLiabilities(this.repository);

  //liabilities
  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) async {
    return await repository.getMainLiabilities();
  }
}
