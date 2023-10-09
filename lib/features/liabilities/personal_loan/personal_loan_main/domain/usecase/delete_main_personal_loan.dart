import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/domain/repository/main_personal_loan_repo.dart';

class DeleteMainPersonalLoanUsecase
    implements UseCase<PersonalLoanEntity, DeleteParams> {
  DeleteMainPersonalLoanUsecase(this.mainPersonalRepository);

  final MainPersonalRepository mainPersonalRepository;

  @override
  Future<Either<Failure, PersonalLoanEntity>> call(DeleteParams params) async {
    return await mainPersonalRepository.deletePersonalLoan(params.id);
  }
}
