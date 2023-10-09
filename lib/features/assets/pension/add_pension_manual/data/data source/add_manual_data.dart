import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/pension_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddManualPensionDataSource {
  Future<PensionsModel> addManualPension(Map<String, dynamic> body);
  Future<PensionsModel> updateManualPension(Map<String, dynamic> body);
}

class AddManualPensionDataSourceImp extends Repository
    implements AddManualPensionDataSource {
  final SharedPreferences sharedPreferences;

  AddManualPensionDataSourceImp({required this.sharedPreferences});
  @override
  Future<PensionsModel> addManualPension(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      // setupToken();
      final result = await Repository().dio
          .post('$financialInformationEndpoint/assets/pensions', data: body);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final pensionModel = PensionsModel.fromJson(result.data);
        await RootApplicationAccess().storeAssets();
        return pensionModel;
      } else {
        // print("failded");
        throw status.failure!;
      }
    } catch (e) {
      // print("ERROR: " + e.toString());
      throw handleThrownException(e);
    }
  }

  @override
  Future<PensionsModel> updateManualPension(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await dio.put(
          '$financialInformationEndpoint/assets/pensions/${body['id']}',
          data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        await RootApplicationAccess().storeAssets();
        return PensionsModel.fromJson(response.data);
      } else {
        // print("failed");
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
