import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/beneficiary_member_model.dart';
import 'package:wedge/core/data_models/trusted_member_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteGetBeneficiaryDataSource {
  Future<BeneficiaryMembersModel> getBeneficiaryMember();

  Future<TrustedMembersModel> getTrustedMember();
}

class RemoteGetBeneficiaryDataSourceImp extends Repository
    implements RemoteGetBeneficiaryDataSource {
  @override
  Future<BeneficiaryMembersModel> getBeneficiaryMember() async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get('/beneficiaries');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        BeneficiaryMembersModel data =
            BeneficiaryMembersModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<TrustedMembersModel> getTrustedMember() async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.get('/trustedMembers');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        TrustedMembersModel data = TrustedMembersModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
