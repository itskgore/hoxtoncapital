import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/repository/get_beneficiary_repo.dart';

class DeleteBeneficiaryDetailsUsecase
    extends UseCase<BeneficiaryMembersEntity, DeleteParams> {
  GetBeneficiaryRepo getBeneficiaryRepo;

  DeleteBeneficiaryDetailsUsecase(this.getBeneficiaryRepo);

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>> call(DeleteParams params) {
    return getBeneficiaryRepo.deleteBeneficiaryMembers(params.id);
  }
}
