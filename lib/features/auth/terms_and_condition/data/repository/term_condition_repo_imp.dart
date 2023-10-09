import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/auth/terms_and_condition/data/datasource/remote_term_condition_datasource.dart';
import 'package:wedge/features/auth/terms_and_condition/domain/repository/term_condition_repository.dart';

class TermConditionRepoImp extends TermConditionRepository {
  final RemoteTermConditionDataSource remoteTermConditionDataSource;

  TermConditionRepoImp(this.remoteTermConditionDataSource);

  @override
  Future<Either<Failure, bool>> acceptTermCondition() async {
    try {
      final result = await remoteTermConditionDataSource.acceptTermCondition();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
