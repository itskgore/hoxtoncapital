import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/repository/get_beneficiary_repo.dart';

class DeleteTrustedDetailsUsecase
    extends UseCase<TrustedMembersEntity, DeleteParams> {
  GetBeneficiaryRepo getBeneficiaryRepo;

  DeleteTrustedDetailsUsecase(this.getBeneficiaryRepo);

  @override
  Future<Either<Failure, TrustedMembersEntity>> call(DeleteParams params) {
    return getBeneficiaryRepo.deleteTrustedMembers(params.id);
  }
}
