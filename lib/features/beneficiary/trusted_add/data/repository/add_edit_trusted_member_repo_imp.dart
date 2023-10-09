import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/beneficiary/trusted_add/data/datasource/remote_add_edit_trusted_member_datasource.dart';
import 'package:wedge/features/beneficiary/trusted_add/domain/repository/add_edit_trusted_member_repo.dart';

class AddEditTrustedMemberRepoImp extends AddEditTrustedMemberRepo {
  final RemoteAddEditTrustedDataSource remoteAddEditTrustedDataSource;

  AddEditTrustedMemberRepoImp({required this.remoteAddEditTrustedDataSource});

  @override
  Future<Either<Failure, TrustedMembersEntity>> addTrustedMember(
      Map<String, dynamic> body) async {
    try {
      final result =
          await remoteAddEditTrustedDataSource.addTrsutedMember(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TrustedMembersEntity>> editTrustedMember(
      Map<String, dynamic> body) async {
    try {
      final result =
          await remoteAddEditTrustedDataSource.editTrsutedMember(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
    ;
  }
}
