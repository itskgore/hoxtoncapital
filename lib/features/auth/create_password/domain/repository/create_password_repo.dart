import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CreatePasswordRepo {
  Future<Either<Failure, Map<String, dynamic>>> createPassword(
      Map<String, dynamic> body);
}
