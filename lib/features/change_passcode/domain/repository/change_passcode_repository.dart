import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../model/change_passcode_params_model.dart';

abstract class ChangePasscodeRepository {
  Future<Either<Failure, dynamic>> changePasscode(
      {required ChangePasscodeParams changePasswordParams});
}
