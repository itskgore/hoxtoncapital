import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_main/domain/repository/get_beneficiary_repo.dart';

class GetBeneficiaryDetailsUsecase
    extends UseCase<BeneficiaryMembersEntity, NoParams> {
  GetBeneficiaryRepo getBeneficiaryRepo;

  GetBeneficiaryDetailsUsecase(this.getBeneficiaryRepo);

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>> call(NoParams params) {
    return getBeneficiaryRepo.geBeneficiaryMembers();
  }
}
