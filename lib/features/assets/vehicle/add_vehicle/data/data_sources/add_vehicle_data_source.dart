import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/vehicle_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddVehicleDataSource {
  Future<VehicleModel> addVehicle(Map<String, dynamic> body);

  Future<VehicleModel> updateVehicle(Map<String, dynamic> body);
}

class AddVehicleDataSourceImpl extends Repository
    implements AddVehicleDataSource {
  // final _sharedPreferences = SharedPreferences.getInstance();
  final SharedPreferences sharedPreferences;

  AddVehicleDataSourceImpl({required this.sharedPreferences});

  @override
  Future<VehicleModel> addVehicle(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .post('${financialInformationEndpoint}/assets/vehicles', data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final assetModel = VehicleModel.fromJson(response.data); // attention
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return assetModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<VehicleModel> updateVehicle(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/assets/vehicles/' + body['id'],
          data: body);
      final status = await hanldeStatusCode(response);

      if (status.status) {
        final assetModel = VehicleModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return assetModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
