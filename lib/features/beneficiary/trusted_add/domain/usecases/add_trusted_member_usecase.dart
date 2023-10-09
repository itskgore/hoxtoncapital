import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/trusted_add/domain/repository/add_edit_trusted_member_repo.dart';

class AddTrustedMemberUsecase
    extends UseCase<TrustedMembersEntity, Map<String, dynamic>> {
  AddEditTrustedMemberRepo addEditTrustedMemberRepo;

  AddTrustedMemberUsecase(this.addEditTrustedMemberRepo);

  @override
  Future<Either<Failure, TrustedMembersEntity>> call(
      Map<String, dynamic> params) {
    return addEditTrustedMemberRepo.addTrustedMember(params);
  }
}
