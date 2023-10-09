import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../../../../core/usecases/usecase.dart';
import '../repository/personal_details_repository.dart';

class PersonalDetailsUseCase
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final PersonalDetailsRepository personalDetailsRepository;

  PersonalDetailsUseCase(this.personalDetailsRepository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) async {
    return await personalDetailsRepository.updatePersonalDetails(params);
  }
}
