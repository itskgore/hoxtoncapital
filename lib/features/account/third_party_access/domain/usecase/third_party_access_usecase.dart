import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/account/third_party_access/data/model/third_party_access_entity.dart';
import 'package:wedge/features/account/third_party_access/domain/model/third_party_url_model.dart';
import 'package:wedge/features/account/third_party_access/domain/repository/third_party_access_repo.dart';

class GetThirdPartyAccessUsecase
    extends UseCase<List<ThirdPartyAccessEntity>, ThirdPartyUrlParams> {
  final ThirdPartyAccessRepo thirdPartyAccessRepo;

  GetThirdPartyAccessUsecase(this.thirdPartyAccessRepo);

  @override
  Future<Either<Failure, List<ThirdPartyAccessEntity>>> call(
      ThirdPartyUrlParams params) {
    return thirdPartyAccessRepo.getThirdPartyAccessDetails(params);
  }
}
