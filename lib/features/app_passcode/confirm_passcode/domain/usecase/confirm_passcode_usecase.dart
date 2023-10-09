import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/app_passcode/confirm_passcode/domain/repository/confirm_passcode_repository.dart';

class ConfirmPasscodeUsecase extends UseCase<dynamic, Map<String, dynamic>> {
  final ConfirmPasscodeRepository confirmPasscodeRepository;

  ConfirmPasscodeUsecase({required this.confirmPasscodeRepository});

  @override
  Future<Either<Failure, dynamic>> call(Map<String, dynamic> params) {
    return confirmPasscodeRepository.confirmPasscode(
        email: params['email'], passcode: params['passcode']);
  }
}
