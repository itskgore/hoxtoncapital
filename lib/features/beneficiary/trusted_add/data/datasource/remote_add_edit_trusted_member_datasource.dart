import 'dart:convert';

import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/trusted_member_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteAddEditTrustedDataSource {
  Future<TrustedMembersModel> addTrsutedMember(Map<String, dynamic> body);

  Future<TrustedMembersModel> editTrsutedMember(Map<String, dynamic> body);
}

class RemoteAddEditTrustedDataSourceImp extends Repository
    implements RemoteAddEditTrustedDataSource {
  @override
  Future<TrustedMembersModel> addTrsutedMember(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.post(
          '${financialInformationEndpoint}/trustedMembers',
          data: json.encode(body));
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

  @override
  Future<TrustedMembersModel> editTrsutedMember(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final result = await Repository().dio.put(
          '${financialInformationEndpoint}/trustedMembers/${body['id']}',
          data: json.encode(body));
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
