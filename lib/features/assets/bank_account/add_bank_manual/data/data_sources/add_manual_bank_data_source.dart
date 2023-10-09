import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/manual_bank_accounts_model.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';

abstract class AddManualBankDataSource {
  Future<ManualBankAccountsModel> addManualBankAccount(
      String name, String country, String currency, ValueEntity currentAmount);

  Future<ManualBankAccountsModel> updateManualBankAccount(String name,
      String country, String currency, ValueEntity currentAmount, String id);
}

class AddManualBankDataSourceImpl extends Repository
    implements AddManualBankDataSource {
  final SharedPreferences sharedPreferences;

  AddManualBankDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ManualBankAccountsModel> addManualBankAccount(String name,
      String country, String currency, ValueEntity currentAmount) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .post('$financialInformationEndpoint/assets/bankAccounts', data: {
        "name": name,
        "country": country,
        "currency": currency,
        "currentAmount": {
          "amount": double.parse(currentAmount.amount.toString()),
          "currency": currentAmount.currency
        }
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final bankModel = ManualBankAccountsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        log(name: "${DateTime.now()}", "return calling : addManualBankAccount");
        return bankModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<ManualBankAccountsModel> updateManualBankAccount(
      String name,
      String country,
      String currency,
      ValueEntity currentAmount,
      String id) async {
    try {
      await isConnectedToInternet();

      final userData = sharedPreferences
          .getString(RootApplicationAccess.loginUserPreferences);
      final data = LoginModel.fromJson(json.decode(userData!));

      dio.options.headers["authorization"] = "bearer ${data.accessToken}";
      final response = await Repository()
          .dio
          .put('$financialInformationEndpoint/assets/bankAccounts/$id', data: {
        "name": name,
        "country": country,
        "currency": currency,
        "currentAmount": {
          "amount": double.parse(currentAmount.amount.toString()),
          "currency": currentAmount.currency
        }
      });
      final status = await hanldeStatusCode(response);

      if (status.status) {
        final bankModel = ManualBankAccountsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return bankModel;
      } else {
        throw status.failure!;
      }
    } on DioException catch (e) {
      throw handleThrownException(e);
    }
  }
}
