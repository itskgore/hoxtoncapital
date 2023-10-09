import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/entities/hoxton_summery_entity.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';

abstract class HoxtonDataSummeryRepository {
  Future<Either<Failure, HoxtonUserDataSUmmeryEntity>> getHoxtonDataSummery();

  Future<Either<Failure, LoginEmailEntity>> getUserDetails();
}
