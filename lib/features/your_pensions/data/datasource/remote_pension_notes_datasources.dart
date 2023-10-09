import 'package:wedge/core/config/repository_config.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../model/pension_notes_model.dart';

abstract class RemotePensionNotesDataSource {
  Future<PensionNotesModel> editPensionNotes(
      Map<String, dynamic> json, String id);
}

class RemotePensionNotesImp extends Repository
    implements RemotePensionNotesDataSource {
  @override
  Future<PensionNotesModel> editPensionNotes(
      Map<String, dynamic> json, String id) async {
    try {
      dio.options.headers["authorization"] = Repository().getToken();
      await isConnectedToInternet();
      String URL = '$financialInformationEndpoint/assets/pensions/$id/notes';
      final result = await Repository().dio.put(URL, data: json);
      final status = await hanldeStatusCode(result);
      if (status.status) {
        final userData = PensionNotesModel.fromJson(result.data);
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
