import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

import '../model/change_passcode_params_model.dart';
import '../repository/change_passcode_repository.dart';

class ChangePasscodeUsecase extends UseCase<dynamic, ChangePasscodeParams> {
  final ChangePasscodeRepository changePasscodeRepository;

  ChangePasscodeUsecase(this.changePasscodeRepository);

  @override
  Future<Either<Failure, dynamic>> call(ChangePasscodeParams params) {
    return changePasscodeRepository.changePasscode(
        changePasswordParams: params);
  }
}
