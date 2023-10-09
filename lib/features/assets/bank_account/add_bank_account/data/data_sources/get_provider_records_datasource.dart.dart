import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/provider_records_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetProviderRecordsdataSource {
  Future<ProviderResponseModel> getproviders(String name);

  Future<ProviderResponseModel> getTopInstitutes(String countryOfResident);
}

class GetProviderRecordsdataSourceImpl extends Repository
    implements GetProviderRecordsdataSource {
  GetProviderRecordsdataSourceImpl();

  @override
  Future<ProviderResponseModel> getproviders(String name) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.get(
          '$userPlatformEndPoint/search/financialInstitutes?institution=$name&page=1');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return ProviderResponseModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }

  @override
  Future<ProviderResponseModel> getTopInstitutes(String country) async {
    try {
      await isConnectedToInternet();
      final response = await Repository().dio.get(
          '$userPlatformEndPoint/get/financialInstitutes?country=$country');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return ProviderResponseModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
