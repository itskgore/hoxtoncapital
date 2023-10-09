import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/change_password/domain/model/change_password_params_model.dart';
import 'package:wedge/features/change_password/domain/repository/change_password_repository.dart';

class ChangePasswordUsecase extends UseCase<dynamic, ChangePasswordParams> {
  final ChangePasswordRepository changePasswordRepository;

  ChangePasswordUsecase(this.changePasswordRepository);

  @override
  Future<Either<Failure, dynamic>> call(ChangePasswordParams params) {
    return changePasswordRepository.changePassword(
        changePasswordParams: params);
  }
}
