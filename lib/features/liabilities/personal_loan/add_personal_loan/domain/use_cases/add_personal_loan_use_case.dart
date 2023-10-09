import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/params/add_update_personal_loan.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/usecases/usecase.dart';
import '../repositories/add_personal_loan_repository.dart';

class AddPersonalLoan
    implements UseCase<PersonalLoanEntity, AddPersonalLoanParams> {
  AddPersonalLoan(this.repository);

  final AddPersonalLoanRepository repository;

  @override
  Future<Either<Failure, PersonalLoanEntity>> call(
      AddPersonalLoanParams params) async {
    return repository.addPersonalLoan(params);
  }
}
