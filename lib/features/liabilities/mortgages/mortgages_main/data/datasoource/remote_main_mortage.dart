import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteMortage {
  Future<Mortgages> deleteMoratgages(String id);

  Future<bool> unlinkMoratgages(Map<String, dynamic> id, String vehicleId);
}

class RemoteMortageImp extends Repository implements RemoteMortage {
  RemoteMortageImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<Mortgages> deleteMoratgages(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '${financialInformationEndpoint}/liabilities/mortgages/' + id,
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final mortageData = Mortgages.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return mortageData;
      } else {
        // print("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> unlinkMoratgages(
      Map<String, dynamic> id, String vehicleId) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/assets/properties/unLink/' +
              vehicleId,
          data: {
            "mortgageId": [
              {"id": id['id']}
            ]
          });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return true;
      } else {
        // print("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
