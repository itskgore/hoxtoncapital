import 'package:wedge/core/config/repository_config.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../model/investment_notes_model.dart';

abstract class RemoteInvestmentNotesDataSource {
  Future<InvestmentNotesModel> editInvestmentNotes(
      Map<String, dynamic> json, String id);
}

class RemoteInvestmentNotesImp extends Repository
    implements RemoteInvestmentNotesDataSource {
  @override
  Future<InvestmentNotesModel> editInvestmentNotes(
      Map<String, dynamic> json, String id) async {
    try {
      dio.options.headers["authorization"] = Repository().getToken();
      await isConnectedToInternet();
      String URL = '$financialInformationEndpoint/assets/investments/$id/notes';
      final result = await Repository().dio.put(URL, data: json);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = InvestmentNotesModel.fromJson(result.data);
        await RootApplicationAccess().storeAssets();
        return userData;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
