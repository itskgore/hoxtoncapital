import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/params/add_update_personal_loan.dart';

import '../../../../../../core/error/failures.dart';

abstract class AddPersonalLoanRepository {
  Future<Either<Failure, PersonalLoanEntity>> addPersonalLoan(
      AddPersonalLoanParams params);

  Future<Either<Failure, PersonalLoanEntity>> updatePersonalLoan(
      AddPersonalLoanParams params);
}
