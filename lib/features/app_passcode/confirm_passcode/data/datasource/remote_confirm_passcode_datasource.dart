import 'package:wedge/core/config/repository_config.dart';

abstract class RemoteConfirmPasscodeDataSource {
  Future<dynamic> confirmPasscode(
      {required String email, required String passcode});
}

class RemoteConfirmPasscodeDataSourceImp extends Repository
    with RemoteConfirmPasscodeDataSource {
  @override
  Future confirmPasscode(
      {required String email, required String passcode}) async {}
}
