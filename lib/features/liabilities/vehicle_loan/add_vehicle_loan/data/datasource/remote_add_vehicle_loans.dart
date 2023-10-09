import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteAddVehicleLoansDataSource {
  Future<VehicleLoans> addVehicleLoans(Map<String, dynamic> body);

  Future<VehicleLoans> updateVehicleLoans(Map<String, dynamic> body);
}

class RemoteAddVehicleLoansDataSourceImp extends Repository
    implements RemoteAddVehicleLoansDataSource {
  RemoteAddVehicleLoansDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<VehicleLoans> addVehicleLoans(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '${financialInformationEndpoint}/liabilities/vehicleLoans',
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final vehicleLoansModel = VehicleLoans.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        await RootApplicationAccess().storeLiabilities();
        return vehicleLoansModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<VehicleLoans> updateVehicleLoans(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/liabilities/vehicleLoans/' +
              body['id'],
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return VehicleLoans.fromJson(response.data);
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
