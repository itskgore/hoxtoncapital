import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CreatePasscodeRepository {
  Future<Either<Failure, dynamic>> createPasscode(Map<String, dynamic> body);
}
