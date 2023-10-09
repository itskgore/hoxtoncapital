import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/auth/terms_and_condition/domain/repository/term_condition_repository.dart';

class AcceptTermConditionUseCase extends UseCase<bool, NoParams> {
  final TermConditionRepository termConditionRepository;

  AcceptTermConditionUseCase(this.termConditionRepository);

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) {
    return termConditionRepository.acceptTermCondition();
  }
}
