import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/account/third_party_access/data/model/third_party_access_model.dart';
import 'package:wedge/features/account/third_party_access/domain/model/third_party_url_model.dart';

import '../../../../../core/config/app_config.dart';

abstract class RemoteThirdPartyAccessData {
  Future<List<ThirdPartyAccessModel>> getThirdPartyAccessDetails(
      ThirdPartyUrlParams thirdPartyUrlParams);
}

class RemoteThirdPartyAccessDataImp extends Repository
    implements RemoteThirdPartyAccessData {
  @override
  Future<List<ThirdPartyAccessModel>> getThirdPartyAccessDetails(
      ThirdPartyUrlParams thirdPartyUrlParams) async {
    try {
      await isConnectedToInternet();
      String URL =
          "$userServicesEndPoint/plugins/${thirdPartyUrlParams.pluginCode}/${thirdPartyUrlParams.serviceCode}/execute";
      final response =
          await Repository().dio.post(URL, data: thirdPartyUrlParams.data);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        if (thirdPartyUrlParams.isUpdate ?? false) {
          return [];
        }
        final List<ThirdPartyAccessModel> thirdPartyModel = [];
        response.data.forEach((e) {
          thirdPartyModel.add(ThirdPartyAccessModel.fromJson(e));
        });
        return thirdPartyModel;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
