import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddUpdateMortgagesDataSource {
  Future<Mortgages> addMortgages(Map<String, dynamic> body);

  Future<Mortgages> updateMortgages(Map<String, dynamic> body);
}

class AddUpdateMortgagesDataSourceImp extends Repository
    implements AddUpdateMortgagesDataSource {
  AddUpdateMortgagesDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<Mortgages> addMortgages(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '${financialInformationEndpoint}/liabilities/mortgages',
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final mortgagesModel = Mortgages.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return mortgagesModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<Mortgages> updateMortgages(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/liabilities/mortgages/' + body['id'],
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final mortgagesModel = Mortgages.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return mortgagesModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
