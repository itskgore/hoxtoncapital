import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/domain/respository/add_edit_beneficiary_repo.dart';

class EditBeneficiaryUsecase
    extends UseCase<BeneficiaryMembersEntity, Map<String, dynamic>> {
  AddEditBeneficiaryRepo addBeneficiaryRepo;

  EditBeneficiaryUsecase(this.addBeneficiaryRepo);

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>> call(
      Map<String, dynamic> params) {
    return addBeneficiaryRepo.editBeneficiary(params, params['id']);
  }
}
