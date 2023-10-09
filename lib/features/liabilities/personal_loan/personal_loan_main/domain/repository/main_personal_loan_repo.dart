import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class MainPersonalRepository {
  Future<Either<Failure, LiabilitiesEntity>> getPersonalLoan();

  Future<Either<Failure, PersonalLoanEntity>> deletePersonalLoan(String id);
}
