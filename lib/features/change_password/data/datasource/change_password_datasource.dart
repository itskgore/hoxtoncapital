import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/change_password/domain/model/change_password_params_model.dart';

abstract class ChangePasswordDatasource {
  Future<dynamic> changePassword(ChangePasswordParams changePasswordParams);
}

class ChangePasswordDatasourceImp extends Repository
    with ChangePasswordDatasource {
  @override
  Future changePassword(ChangePasswordParams changePasswordParams) async {
    try {
      await isConnectedToInternet();
      final response = await Repository()
          .dio
          .post(changePasswordParams.url, data: changePasswordParams.body);
      final status = await hanldeStatusCode(response);
      if (status.status) {
        return response.data;
      } else {
        throw status.failure ?? ServerFailure();
      }
    } catch (e) {
      handleThrownException(e);
    }
  }
}
