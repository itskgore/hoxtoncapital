import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/core/usecases/usecase.dart';
import 'package:wedge/features/beneficiary/trusted_add/domain/repository/add_edit_trusted_member_repo.dart';

class EditTrustedMemberUsecase
    extends UseCase<TrustedMembersEntity, Map<String, dynamic>> {
  final AddEditTrustedMemberRepo addEditTrustedMemberRepo;

  EditTrustedMemberUsecase(this.addEditTrustedMemberRepo);

  @override
  Future<Either<Failure, TrustedMembersEntity>> call(
      Map<String, dynamic> params) {
    return addEditTrustedMemberRepo.editTrustedMember(params);
  }
}
