import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/account/third_party_access/data/model/third_party_access_entity.dart';
import 'package:wedge/features/account/third_party_access/domain/model/third_party_url_model.dart';

abstract class ThirdPartyAccessRepo {
  Future<Either<Failure, List<ThirdPartyAccessEntity>>>
      getThirdPartyAccessDetails(ThirdPartyUrlParams thirdPartyUrlParams);
}
