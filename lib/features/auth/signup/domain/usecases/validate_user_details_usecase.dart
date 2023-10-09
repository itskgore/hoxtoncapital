import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repository/signup_details_repo.dart';

class ValidateUserDetailsUseCase
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final SignUpRepository signUpRepository;

  ValidateUserDetailsUseCase(this.signUpRepository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) async {
    return await signUpRepository.validateUserDetails(params);
  }
}
