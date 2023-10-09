import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/data/datasource/local_get_liabilites.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/domain/repository/add_liabilities_repository.dart';

class AddLiabilitiesRepoImp implements AddLiabilitiesRepo {
  AddLiabilitiesRepoImp({required this.localGetLiabilities});

  final LocalGetLiabilities localGetLiabilities;

  @override
  Future<Either<Failure, LiabilitiesEntity>> getLiabilities() async {
    try {
      final result = await localGetLiabilities.getLiabilities();
      return Right(result);
    } on CacheFailure {
      return Left(CacheFailure());
    }
  }
}
