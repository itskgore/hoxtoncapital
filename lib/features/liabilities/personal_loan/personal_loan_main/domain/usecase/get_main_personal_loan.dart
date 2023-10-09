import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/liabilities/personal_loan/personal_loan_main/domain/repository/main_personal_loan_repo.dart';

class GetMainPersonalLoanUsecase
    implements UseCase<LiabilitiesEntity, NoParams> {
  GetMainPersonalLoanUsecase(this.mainPersonalRepository);

  final MainPersonalRepository mainPersonalRepository;

  @override
  Future<Either<Failure, LiabilitiesEntity>> call(NoParams params) async {
    return await mainPersonalRepository.getPersonalLoan();
  }
}
