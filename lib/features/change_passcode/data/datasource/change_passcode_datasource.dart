import 'package:wedge/core/config/repository_config.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/change_passcode/domain/model/change_passcode_params_model.dart';

abstract class ChangePasscodeDatasource {
  Future<dynamic> changePasscode(ChangePasscodeParams changePasswordParams);
}

class ChangePasscodeDatasourceImp extends Repository
    with ChangePasscodeDatasource {
  @override
  Future changePasscode(ChangePasscodeParams changePasswordParams) async {
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
