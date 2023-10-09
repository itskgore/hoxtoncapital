import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/repository/personal_details_repository.dart';
import '../datasource/remote_personal_details_datasource.dart';

class PersonalDetailsRepositoryImp implements PersonalDetailsRepository {
  final PersonalDetailsSource personalDetailsSource;

  PersonalDetailsRepositoryImp({required this.personalDetailsSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> updatePersonalDetails(
      Map<String, dynamic> body) async {
    try {
      final result = await personalDetailsSource.updatePersonDetails(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
