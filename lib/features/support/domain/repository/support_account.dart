import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddSupportAccontRepo {
  Future<Either<Failure, Map<String, dynamic>>> postSupport(
      Map<String, dynamic> body);
}
