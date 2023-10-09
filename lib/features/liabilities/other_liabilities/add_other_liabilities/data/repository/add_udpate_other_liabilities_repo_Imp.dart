import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/data/datasource/remote_add_update_other_liabilities_datasource.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/params/add_update_other_liabilities_params.dart';
import 'package:wedge/features/liabilities/other_liabilities/add_other_liabilities/domain/repository/add_update_other_liabilities_repo.dart';

class AddUpdateOtherLiabilitiesRepoImp
    implements AddUpdateOtherLiabilitiesRepo {
  AddUpdateOtherLiabilitiesRepoImp(
      {required this.remoteAddUpdateOtherLiabilitiesDataSource});

  final RemoteAddUpdateOtherLiabilitiesDataSource
      remoteAddUpdateOtherLiabilitiesDataSource;

  @override
  Future<Either<Failure, OtherLiabilitiesEntity>> addOtherLiabilities(
      AddUpdateOtherLiabilitiesParams params) async {
    try {
      final result = await remoteAddUpdateOtherLiabilitiesDataSource
          .addOtherLiabilities(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, OtherLiabilitiesEntity>> updateOtherLiabilities(
      AddUpdateOtherLiabilitiesParams params) async {
    try {
      final result = await remoteAddUpdateOtherLiabilitiesDataSource
          .updateOtherLiabilities(params.toJson());
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
