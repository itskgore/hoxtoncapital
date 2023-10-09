import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/data/models/hoxton_summery_model.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/verified_user_model.dart';

abstract class HoxtonUserDataSource {
  Future<HoxtonSummeryModel> getHoxtonDataSummery();
  Future<VerifiedUser> getUserDetails();
}

class HoxtonUserDataSourceImpl extends Repository
    implements HoxtonUserDataSource {
  final SharedPreferences sharedPreferences;
  HoxtonUserDataSourceImpl({required this.sharedPreferences});

  @override
  Future<HoxtonSummeryModel> getHoxtonDataSummery() async {
    try {
      final response = await Repository()
          .dio
          .get('$financialInformationEndpoint/onboardingSummary');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return HoxtonSummeryModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } on DioException catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<VerifiedUser> getUserDetails() async {
    try {
      final res = sharedPreferences
          .getString(RootApplicationAccess.emailUserPreferences);
      return VerifiedUser.fromJson(json.decode(res!));
    } catch (e) {
      throw const CacheFailure();
    }
  }
}
