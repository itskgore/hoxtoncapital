import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/data_models/investment_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteInvestmentsSource {
  Future<InvestmentsModel> deleteInvestment(String id);
}

class RemoteInvestmentsSourceImpl extends Repository
    implements RemoteInvestmentsSource {
  final SharedPreferences sharedPreferences;

  RemoteInvestmentsSourceImpl({required this.sharedPreferences});

  @override
  Future<InvestmentsModel> deleteInvestment(String id) async {
    try {
      await isConnectedToInternet();

      final response = await Repository().dio.delete(
            '$financialInformationEndpoint/assets/investments/$id',
          );
      final status = await hanldeStatusCode(response);
      if (status.status) {
        final investmentData = InvestmentsModel.fromJson(response.data);
        await RootApplicationAccess().storeAssets();
        if (investmentData.source.toString().toLowerCase() != 'manual') {
          await RootApplicationAccess().storeLiabilities();
        }
        return investmentData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
