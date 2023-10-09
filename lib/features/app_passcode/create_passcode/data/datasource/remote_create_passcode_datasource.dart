import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/enviroment_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';

abstract class RemoteCreatePasscodeDatasource {
  Future<dynamic> createPasscode(Map<String, dynamic> body);
}

class RemoteCreatePasscodeDatasourceImp extends Repository
    implements RemoteCreatePasscodeDatasource {
  @override
  Future createPasscode(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      body['accessToken'] =
          RootApplicationAccess().getToken().replaceAll("bearer ", "");
      final response = await Repository()
          .dio
          .post(body['url'] ?? '${authBaseUrl}change-passcode', data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure!;
      }
    } catch (e) {
      return handleThrownException(e);
    }
  }
}
