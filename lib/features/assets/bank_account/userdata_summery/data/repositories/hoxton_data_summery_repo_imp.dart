import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/data/data_sources/hoxton_userdata_source.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/entities/hoxton_summery_entity.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/repositories/hoxton_data_summery_repository.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/verified_user_model.dart';

class HoxtonDataSummeryRepositoryImpl implements HoxtonDataSummeryRepository {
  final HoxtonUserDataSource hoxtonUserDataSource;

  HoxtonDataSummeryRepositoryImpl({required this.hoxtonUserDataSource});

  @override
  Future<Either<Failure, HoxtonUserDataSUmmeryEntity>>
      getHoxtonDataSummery() async {
    try {
      final result = await hoxtonUserDataSource.getHoxtonDataSummery(); //change
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  Future<Either<Failure, VerifiedUser>> getUserDetails() async {
    try {
      final result = await hoxtonUserDataSource.getUserDetails(); //change
      return Right(result);
    } on CacheFailure {
      return const Left(CacheFailure());
    }
  }
}
