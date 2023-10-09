import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/pension_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemotePensionsDataSource {
  Future<PensionsModel> deletePension(String id);
}

class RemotePensionsDataSourceImp extends Repository
    implements RemotePensionsDataSource {
  RemotePensionsDataSourceImp({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<PensionsModel> deletePension(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/assets/pensions/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final pensionsData = PensionsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        if (pensionsData.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeLiabilities();
        }
        return pensionsData;
      } else {
        throw status.failure ?? const ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
