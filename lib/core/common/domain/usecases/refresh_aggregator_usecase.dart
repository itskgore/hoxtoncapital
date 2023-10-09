import 'package:dartz/dartz.dart';
import 'package:wedge/core/common/domain/repository/common_repository.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';

class CommonRefreshAggregatorAccountUseCase
    implements UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final CommonRepository repository;

  CommonRefreshAggregatorAccountUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) async {
    return await repository.refreshAgreegatorAccount(params);
  }
}
