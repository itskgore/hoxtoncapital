import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/provider_token_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetYodleeTokenDataSource {
  Future<ProviderTokenModel> getYodleeToken(
      {required String provider, required Map<String, dynamic> body});
}

class GetYodleeTokenDataSourceImpl extends Repository
    implements GetYodleeTokenDataSource {
  GetYodleeTokenDataSourceImpl();

  @override
  Future<ProviderTokenModel> getYodleeToken(
      {required String provider, required Map<String, dynamic> body}) async {
    try {
      final response = await Repository()
          .dio
          .post('$financialInformationEndpoint/tokens/$provider', data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        // print(response.data);
        return ProviderTokenModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
