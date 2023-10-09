import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddManualPensionRepo {
  Future<Either<Failure, PensionsEntity>> addManualPension(
      Map<String, dynamic> body);

  Future<Either<Failure, PensionsEntity>> updateManualPension(
      Map<String, dynamic> body);
}
