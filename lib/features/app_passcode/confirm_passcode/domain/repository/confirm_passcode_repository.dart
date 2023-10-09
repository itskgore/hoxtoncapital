import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class ConfirmPasscodeRepository {
  Future<Either<Failure, dynamic>> confirmPasscode(
      {required String email, required String passcode});
}
