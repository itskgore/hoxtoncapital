import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';

abstract class CustomAssetsDropDownRepo {
  Future<Either<Failure, List<dynamic>>> getData();
}
