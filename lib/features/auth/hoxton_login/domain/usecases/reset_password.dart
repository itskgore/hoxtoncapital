import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

import 'verify_email_usecase.dart';

class ResetPassword implements UseCase<bool, EmailParams> {
  final LoginRepository repository;

  ResetPassword(this.repository);

  @override
  Future<Either<Failure, bool>> call(EmailParams params) async {
    return await repository.resetPassword(params.email);
  }
}
