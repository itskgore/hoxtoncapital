import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddEditTrustedMemberRepo {
  Future<Either<Failure, TrustedMembersEntity>> addTrustedMember(
      Map<String, dynamic> body);

  Future<Either<Failure, TrustedMembersEntity>> editTrustedMember(
    Map<String, dynamic> body,
  );
}
