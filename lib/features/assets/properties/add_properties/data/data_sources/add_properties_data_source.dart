import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/property_model.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddPropertiesDataSource {
  Future<PropertyModel> addProperties(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages);

  Future<PropertyModel> updateProperties(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages);
}

class AddPropertiesDataSourceImpl extends Repository
    implements AddPropertiesDataSource {
  final SharedPreferences sharedPreferences;

  AddPropertiesDataSourceImpl({required this.sharedPreferences});

  @override
  Future<PropertyModel> addProperties(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
        '$financialInformationEndpoint/assets/properties',
        data: {
          "name": name,
          "country": country,
          "purchasedValue": {
            "amount": purchasedValue.amount,
            "currency": purchasedValue.currency
          },
          "currentValue": {
            "amount": currentValue.amount,
            "currency": currentValue.currency
          },
          "hasRentalIncome": hasRentalIncome,
          "rentalIncome": {
            "monthlyRentalIncome": {
              "amount": rentalIncome.monthlyRentalIncome.amount,
              "currency": rentalIncome.monthlyRentalIncome.currency
            }
          },
          "currency": rentalIncome.monthlyRentalIncome.currency,
          "hasMortgage": hasMortgage,
          "mortgages": mortgages
        },
      );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = PropertyModel.fromJson(response.data); // attention
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return assetModel;
      } else {
        // print("failded");
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<PropertyModel> updateProperties(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
        '$financialInformationEndpoint/assets/properties/$id',
        data: {
          "name": name,
          "country": country,
          "purchasedValue": {
            "amount": purchasedValue.amount,
            "currency": purchasedValue.currency
          },
          "currentValue": {
            "amount": currentValue.amount,
            "currency": currentValue.currency
          },
          "hasRentalIncome": hasRentalIncome,
          "rentalIncome": {
            "monthlyRentalIncome": {
              "amount": rentalIncome.monthlyRentalIncome.amount,
              "currency": rentalIncome.monthlyRentalIncome.currency
            }
          },
          "currency": rentalIncome.monthlyRentalIncome.currency,
          "hasMortgage": hasMortgage,
          "mortgages": mortgages
        },
      );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = PropertyModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return assetModel;
      } else {
        // print("failed");
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
