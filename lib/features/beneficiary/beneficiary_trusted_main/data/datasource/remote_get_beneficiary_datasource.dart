import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/beneficiary_member_model.dart';
import 'package:wedge/core/data_models/trusted_member_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteGetBeneficiaryDataSource {
  Future<BeneficiaryMembersModel> getBeneficiaryMember();

  Future<TrustedMembersModel> getTrustedMember();

  Future<BeneficiaryMembersModel> deleteBeneficiaryMember(String id);

  Future<TrustedMembersModel> deleteTrustedMember(String id);
}

class RemoteGetBeneficiaryDataSourceImp extends Repository
    implements RemoteGetBeneficiaryDataSource {
  @override
  Future<BeneficiaryMembersModel> getBeneficiaryMember() async {
    try {
      await isConnectedToInternet();
      final result = await Repository()
          .dio
          .get('${financialInformationEndpoint}/beneficiaries');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        if (result.data.isEmpty) {
          BeneficiaryMembersModel data =
              BeneficiaryMembersModel.fromJson({"isEmpty": true});
          return data;
        } else {
          BeneficiaryMembersModel data =
              BeneficiaryMembersModel.fromJson(result.data[0]);
          return data;
        }
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
      final result = await Repository()
          .dio
          .get('${financialInformationEndpoint}/trustedMembers');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        if (result.data.isEmpty) {
          TrustedMembersModel data =
              TrustedMembersModel.fromJson({"isEmpty": true});
          return data;
        } else {
          TrustedMembersModel data =
              TrustedMembersModel.fromJson(result.data[0]);
          return data;
        }
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<BeneficiaryMembersModel> deleteBeneficiaryMember(String id) async {
    try {
      await isConnectedToInternet();
      final result = await Repository()
          .dio
          .delete('${financialInformationEndpoint}/beneficiaries/${id}');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        BeneficiaryMembersModel data =
            BeneficiaryMembersModel.fromJson({"isEmpty": true});
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<TrustedMembersModel> deleteTrustedMember(String id) async {
    try {
      await isConnectedToInternet();
      final result = await Repository()
          .dio
          .delete('${financialInformationEndpoint}/trustedMembers/${id}');
      final status = await hanldeStatusCode(result);
      if (status.status) {
        TrustedMembersModel data =
            TrustedMembersModel.fromJson({"isEmpty": true});
        return data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
