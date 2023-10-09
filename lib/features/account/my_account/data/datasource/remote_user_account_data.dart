import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/enviroment_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/tenant_model.dart';
import 'package:wedge/core/data_models/user_account_data_model.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/helpers/firebase_analytics.dart';
import 'package:wedge/dependency_injection.dart';

abstract class RemoteUserAccountData {
  Future<UserAccountDataModel> getUserDetails();

  Future<UserAccountDataModel> editUserDetails(Map<String, dynamic> json);

  Future<UserPreferencesModel> editUserPreferences(
      Map<String, dynamic> json, String id);

  Future<UserPreferencesModel> getUserPrefences();

  Future<TenantModel> getTenant();
}

class RemoteUserAccountDataImp extends Repository
    implements RemoteUserAccountData {
  @override
  Future<UserAccountDataModel> getUserDetails() async {
    try {
      await isConnectedToInternet();

      final result = await Repository().dio.get(
            '$identityEndpoint/auth/users/me',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = UserAccountDataModel.fromJson(result.data);
        await RootApplicationAccess().storeUserDetails(userData);
        return userData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<UserAccountDataModel> editUserDetails(
      Map<String, dynamic> json) async {
    try {
      dio.options.headers["authorization"] = Repository().getToken();
      await isConnectedToInternet();
      final result = await Repository()
          .dio
          .put('$identityEndpoint/auth/users/me', data: json);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = UserAccountDataModel.fromJson(result.data);
        await RootApplicationAccess().storeUserDetails(userData);
        return userData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<UserPreferencesModel> editUserPreferences(
      Map<String, dynamic> json, String id) async {
    try {
      dio.options.headers["authorization"] = Repository().getToken();
      await isConnectedToInternet();
      final result = await Repository()
          .dio
          .put('$userPreferenceEndpoint/userPreferences/$id', data: json);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = UserPreferencesModel.fromJson(result.data);
        AppAnalytics().trackScreen(
            screenName: "Base Currency Change Event",
            parameters: {'screenName': 'Base Currency Change Event'});
        // await RootApplicationAccess().storeUserDetails(userData);
        return userData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<UserPreferencesModel> getUserPrefences() async {
    try {
      await isConnectedToInternet();
      dio.options.headers["authorization"] = Repository().getToken();
      await isConnectedToInternet();
      final result = await Repository().dio.get(
            '/user-preference/v1/userPreferences?resourceId=general&resourceType=general',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = UserPreferencesModel.fromJson(result.data);
        locator<SharedPreferences>().setString(
            RootApplicationAccess.userPreferences, jsonEncode(userData));

        return userData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<TenantModel> getTenant() async {
    try {
      await isConnectedToInternet();
      dio.options.headers["authorization"] = Repository().getToken();
      await isConnectedToInternet();

      final result = await Repository().dio.get(
            '$identityEndpoint/tenants/${appTheme.clientName?.toLowerCase()}$env',
          );
      final status = await hanldeStatusCode(result);
      if (status.status) {
        return TenantModel.fromJson(result.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
