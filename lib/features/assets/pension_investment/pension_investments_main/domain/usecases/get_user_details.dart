import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/repositories/hoxton_data_summery_repository.dart';
import 'package:wedge/features/auth/hoxton_login/domain/entities/login_email_entity.dart';

class GetUserDetails implements UseCase<LoginEmailEntity, NoParams> {
  final HoxtonDataSummeryRepository repository;

  GetUserDetails(this.repository);

  @override
  Future<Either<Failure, LoginEmailEntity>> call(NoParams params) async {
    return await repository.getUserDetails();
  }
}
