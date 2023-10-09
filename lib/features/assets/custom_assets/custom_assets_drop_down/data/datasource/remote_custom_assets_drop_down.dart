import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteCustomAssetsDropDown {
  Future<List<dynamic>> getData();
}

class RemoteCustomAssetsDropDownImp extends Repository
    implements RemoteCustomAssetsDropDown {
  @override
  Future<List> getData() async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.get(
            '$userPlatformEndPoint/customAssetTypes',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
