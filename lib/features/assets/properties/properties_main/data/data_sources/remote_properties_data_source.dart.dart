import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/property_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

abstract class RemotePropertiesSource {
  Future<PropertyModel> deleteProperty(String id);

  Future<bool> unLinkProperty(UnlinkParams params);
}

class RemotePropertiesSourceImpl extends Repository
    implements RemotePropertiesSource {
  final SharedPreferences sharedPreferences;

  RemotePropertiesSourceImpl({required this.sharedPreferences});

  @override
  Future<PropertyModel> deleteProperty(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/assets/properties/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final propertyModel = PropertyModel.fromJson(response.data);
        await RootApplicationAccess().storeLiabilities();
        await RootApplicationAccess().storeAssets();
        return propertyModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }

  @override
  Future<bool> unLinkProperty(UnlinkParams params) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.put(
          '$financialInformationEndpoint/liabilities/mortgages/unLink/${params.loanId}',
          data: {
            "propertyId": [
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
