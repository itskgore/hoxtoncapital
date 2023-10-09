import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';

abstract class PersonalDetailsRepository {
  Future<Either<Failure, Map<String, dynamic>>> updatePersonalDetails(
      Map<String, dynamic> body);
}
