import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/entities/hoxton_summery_entity.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/repositories/hoxton_data_summery_repository.dart';

class GetHoxtonUserDataSummery
    implements UseCase<HoxtonUserDataSUmmeryEntity, NoParams> {
  final HoxtonDataSummeryRepository repository;

  GetHoxtonUserDataSummery(this.repository);

  @override
  Future<Either<Failure, HoxtonUserDataSUmmeryEntity>> call(
      NoParams params) async {
    return await repository.getHoxtonDataSummery();
  }
}
