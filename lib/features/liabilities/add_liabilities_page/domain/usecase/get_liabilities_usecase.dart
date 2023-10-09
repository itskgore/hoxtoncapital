import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/domain/repository/add_liabilities_repository.dart';

class GetLiabilities implements UseCase<LiabilitiesEntity, NoParams> {
  GetLiabilities(this.addLiabilitiesRepo);

  final AddLiabilitiesRepo addLiabilitiesRepo;

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) async {
    return await addLiabilitiesRepo.getLiabilities();
  }
}
