import 'package:dartz/dartz.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/support/domain/repository/support_account.dart';

class AddSupportAccountUsecase
    extends UseCase<Map<String, dynamic>, Map<String, dynamic>> {
  final AddSupportAccontRepo addSupportAccontRepo;

  AddSupportAccountUsecase(this.addSupportAccontRepo);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      Map<String, dynamic> params) {
    return addSupportAccontRepo.postSupport(params);
  }
}
