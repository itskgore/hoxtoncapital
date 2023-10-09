import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/asset_liability_onboarding_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetAccountDataSource {
  Future<AssetLiabilityOnboardingListModel> getAccountData(String instituteId);
}

class GetAccountDataSourceImpl extends Repository
    implements GetAccountDataSource {
  GetAccountDataSourceImpl();

  @override
  Future<AssetLiabilityOnboardingListModel> getAccountData(
      String instituteId) async {
    try {
      await isConnectedToInternet();
      await RootApplicationAccess().storeAssets();
      await RootApplicationAccess().storeLiabilities();
      final response = await Repository().dio.get(
          '$financialInformationEndpoint/fi/linkedAccounts?institutionId=$instituteId');
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return AssetLiabilityOnboardingListModel.fromJson(response.data);
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
