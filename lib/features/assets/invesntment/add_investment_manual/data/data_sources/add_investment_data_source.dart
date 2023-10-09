import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/investment_model.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddInvestmentDataSource {
  Future<InvestmentsModel> addInvestment(String id, String name, String country,
      String policyNumber, ValueEntity initialValue, ValueEntity currentValue);
  Future<InvestmentsModel> updateInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue);
}

class AddInvestmentDataSourceImpl extends Repository
    implements AddInvestmentDataSource {
  // final _sharedPreferences = SharedPreferences.getInstance();
  final SharedPreferences sharedPreferences;

  AddInvestmentDataSourceImpl({required this.sharedPreferences});

  @override
  Future<InvestmentsModel> addInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue) async {
    try {
      await isConnectedToInternet();
      log(name: "${DateTime.now()}", "start calling : addInvestment");
      final response = await Repository()
          .dio
          .post('$financialInformationEndpoint/assets/investments', data: {
        "name": name,
        "country": country,
        "policyNumber": policyNumber,
        "initialValue": {
          "amount": double.parse(initialValue.amount.toString()),
          "currency": initialValue.currency
        },
        "currentValue": {
          "amount": double.parse(currentValue.amount.toString()),
          "currency": currentValue.currency
        }
      });
      log(name: "${DateTime.now()}", "start calling : addInvestment");
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeAssets();
        return InvestmentsModel.fromJson(response.data);
      } else {
        // print("failded");
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<InvestmentsModel> updateInvestment(
      String id,
      String name,
      String country,
      String policyNumber,
      ValueEntity initialValue,
      ValueEntity currentValue) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .put('$financialInformationEndpoint/assets/investments/$id', data: {
        "id": id,
        "name": name,
        "country": country,
        "policyNumber": policyNumber,
        "initialValue": {
          "amount": double.parse(initialValue.amount.toString()),
          "currency": initialValue.currency
        },
        "currentValue": {
          "amount": double.parse(currentValue.amount.toString()),
          "currency": currentValue.currency
        }
        //{"amount": 22.00, "currency": "AED"}
      });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = InvestmentsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        return assetModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
