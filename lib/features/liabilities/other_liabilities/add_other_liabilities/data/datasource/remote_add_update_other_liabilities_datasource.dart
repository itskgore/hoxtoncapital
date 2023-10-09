import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/other_liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteAddUpdateOtherLiabilitiesDataSource {
  Future<OtherLiabilities> addOtherLiabilities(Map<String, dynamic> body);

  Future<OtherLiabilities> updateOtherLiabilities(Map<String, dynamic> body);
}

class RemoteAddUpdateOtherLiabilitiesDataSourceImp extends Repository
    implements RemoteAddUpdateOtherLiabilitiesDataSource {
  RemoteAddUpdateOtherLiabilitiesDataSourceImp(
      {required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<OtherLiabilities> addOtherLiabilities(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.post(
          '${financialInformationEndpoint}/liabilities/otherLiabilities',
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final otherLiabilitiesModel = OtherLiabilities.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        return otherLiabilitiesModel;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<OtherLiabilities> updateOtherLiabilities(
      Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '${financialInformationEndpoint}/liabilities/otherLiabilities/' +
              body['id'],
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final OtherLiabilityModel = OtherLiabilities.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        return OtherLiabilityModel;
      } else {
        // print("failed");
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
