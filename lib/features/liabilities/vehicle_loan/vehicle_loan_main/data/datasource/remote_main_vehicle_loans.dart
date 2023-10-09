import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteVehicleLoans {
  Future<VehicleLoans> deleteVehicleLoans(String id);

  Future<bool> unlinkVehicleLoans(Map<String, dynamic> id, String vehicleId);

  Future<bool> unlinkVehicleLoansData(
      Map<String, dynamic> id, String vehicleId);
}

class RemoteVehicleLoansImp extends Repository implements RemoteVehicleLoans {
  RemoteVehicleLoansImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<VehicleLoans> deleteVehicleLoans(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '${financialInformationEndpoint}/liabilities/vehicleLoans/' + id,
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final vehicleLoanData = VehicleLoans.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return vehicleLoanData;
      } else {
        // log("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> unlinkVehicleLoans(
      Map<String, dynamic> id, String vehicleId) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/assets/vehicles/unLink/' + vehicleId,
          data: {
            "loanId": [
              {"id": id['id']}
            ]
          });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return true;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> unlinkVehicleLoansData(
      Map<String, dynamic> id, String vehicleId) async {
    try {
      await isConnectedToInternet();
      final response = await dio.put(
          '${financialInformationEndpoint}/liabilities/vehicleLoans/unLink/' +
              id['id'],
          data: {
            "vehicleId": [
              {"id": vehicleId}
            ]
          });
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return true;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
