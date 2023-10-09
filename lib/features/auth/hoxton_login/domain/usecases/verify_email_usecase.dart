import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/repositories/login_repository.dart';

class VerifyEmail implements UseCase<LoginEmailEntity, EmailParams> {
  final LoginRepository repository;

  VerifyEmail(this.repository);

  @override
  Future<Either<Failure, LoginEmailEntity>> call(EmailParams params) async {
    return await repository.verifyEmail(params.email);
  }
}

class EmailParams extends Equatable {
  final String email;

  EmailParams({required this.email});

  @override
  List<Object> get props => [email];
}
