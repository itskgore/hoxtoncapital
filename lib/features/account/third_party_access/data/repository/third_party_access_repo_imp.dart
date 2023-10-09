import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/account/third_party_access/data/datasource/remote_data_third_party_access.dart';
import 'package:wedge/features/account/third_party_access/data/model/third_party_access_model.dart';
import 'package:wedge/features/account/third_party_access/domain/model/third_party_url_model.dart';
import 'package:wedge/features/account/third_party_access/domain/repository/third_party_access_repo.dart';

class UserThirdPartyRepoImp implements ThirdPartyAccessRepo {
  final RemoteThirdPartyAccessData remoteThirdPartyAccessData;

  UserThirdPartyRepoImp({required this.remoteThirdPartyAccessData});

  @override
  Future<Either<Failure, List<ThirdPartyAccessModel>>>
      getThirdPartyAccessDetails(
          ThirdPartyUrlParams thirdPartyUrlParams) async {
    try {
      final result = await remoteThirdPartyAccessData
          .getThirdPartyAccessDetails(thirdPartyUrlParams);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
