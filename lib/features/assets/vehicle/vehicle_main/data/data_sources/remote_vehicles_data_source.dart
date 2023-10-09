import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/vehicle_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

abstract class RemoteVehiclesSource {
  Future<VehicleModel> deleteVehicle(String id);

  Future<bool> unlinkVehicle(UnlinkParams params);
}

class RemoteVehiclesSourceImpl extends Repository
    implements RemoteVehiclesSource {
  final SharedPreferences sharedPreferences;

  RemoteVehiclesSourceImpl({required this.sharedPreferences});

  @override
  Future<VehicleModel> deleteVehicle(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '${financialInformationEndpoint}/assets/vehicles/' + id,
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final vehiclesData = VehicleModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return vehiclesData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> unlinkVehicle(UnlinkParams params) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/liabilities/vehicleLoans/unLink/' +
              params.loanId,
          data: {
            "vehicleId": [
              {"id": params.vehicleId}
            ]
          });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return true;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
