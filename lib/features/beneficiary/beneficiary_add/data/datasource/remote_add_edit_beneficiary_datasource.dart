import 'dart:convert';

import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/beneficiary_member_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteAddEditBeneficairyDataSource {
  Future<BeneficiaryMembersModel> addBeneficiaryMember(
      Map<String, dynamic> body);

  Future<BeneficiaryMembersModel> editBeneficiaryMember(
      Map<String, dynamic> body, String id);
}

class RemoteAddEditBeneficairyDataSourceImp extends Repository
    implements RemoteAddEditBeneficairyDataSource {
  @override
  Future<BeneficiaryMembersModel> addBeneficiaryMember(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.post(
          '$financialInformationEndpoint/beneficiaries',
          data: json.encode(body));
      final status = await hanldeStatusCode(result);
      if (status.status) {
        BeneficiaryMembersModel data =
            BeneficiaryMembersModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<BeneficiaryMembersModel> editBeneficiaryMember(
      Map<String, dynamic> body, String id) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.put(
          '$financialInformationEndpoint/beneficiaries/$id',
          data: json.encode(body));
      final status = await hanldeStatusCode(result);
      if (status.status) {
        BeneficiaryMembersModel data =
            BeneficiaryMembersModel.fromJson(result.data);
        return data;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
