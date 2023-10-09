import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CreatePasswordDataSource {
  Future<Map<String, dynamic>> createPassword(Map<String, dynamic> body);
}

class CreatePasswordDataSourceImp extends Repository
    implements CreatePasswordDataSource {
  @override
  Future<Map<String, dynamic>> createPassword(Map<String, dynamic> body) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .post('$identityEndpoint/auth/resetPassword', data: body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return {"status": response.statusCode, "success": "done"};
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      throw handleThrownException(e);
    }
  }
}
