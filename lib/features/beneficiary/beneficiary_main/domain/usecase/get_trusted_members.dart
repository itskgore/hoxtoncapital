import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_main/domain/repository/get_beneficiary_repo.dart';

class GetTrustedDetailsUsecase extends UseCase<TrustedMembersEntity, NoParams> {
  GetBeneficiaryRepo getBeneficiaryRepo;

  GetTrustedDetailsUsecase(this.getBeneficiaryRepo);

  @override
  Future<Either<Failure, TrustedMembersEntity>> call(NoParams params) {
    return getBeneficiaryRepo.getTrustedMembers();
  }
}
