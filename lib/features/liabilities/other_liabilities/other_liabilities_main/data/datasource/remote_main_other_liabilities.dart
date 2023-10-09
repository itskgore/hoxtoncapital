import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/other_liabilities_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteOtherLiabilitiesDatasource {
  Future<OtherLiabilities> deleteotherLiabilities(String id);
}

class RemoteOtherLiabilitiesDatasourceImp extends Repository
    implements RemoteOtherLiabilitiesDatasource {
  RemoteOtherLiabilitiesDatasourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<OtherLiabilities> deleteotherLiabilities(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '${financialInformationEndpoint}/liabilities/otherLiabilities/' +
                id,
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final otherLiabilitiesData = OtherLiabilities.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        if (otherLiabilitiesData.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeAssets();
        }
        return otherLiabilitiesData;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
