import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/other_assets_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteCustomAssetsSource {
  Future<OtherAssetsModel> deleteCustomAsset(String id);
}

class RemoteCustomAssetsSourceImpl extends Repository
    implements RemoteCustomAssetsSource {
  final SharedPreferences sharedPreferences;

  RemoteCustomAssetsSourceImpl({required this.sharedPreferences});

  @override
  Future<OtherAssetsModel> deleteCustomAsset(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/assets/otherAssets/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final otherAssetsModel = OtherAssetsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        if (otherAssetsModel.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeLiabilities();
        }
        return otherAssetsModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
