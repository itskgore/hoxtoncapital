import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/repositories/add_personal_loan_repository.dart';
import 'package:wedge/features/liabilities/personal_loan/add_personal_loan/domain/use_cases/params/add_update_personal_loan.dart';

class UpdatePersonLoan
    extends UseCase<PersonalLoanEntity, AddPersonalLoanParams> {
  UpdatePersonLoan(this.addPersonalLoanRepository);

  final AddPersonalLoanRepository addPersonalLoanRepository;

  @override
  Future<Either<Failure, PersonalLoanEntity>> call(
      AddPersonalLoanParams params) async {
    return await addPersonalLoanRepository.updatePersonalLoan(params);
  }
}
