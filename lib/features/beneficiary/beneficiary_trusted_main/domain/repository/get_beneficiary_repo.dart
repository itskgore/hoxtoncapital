import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetBeneficiaryRepo {
  Future<Either<Failure, TrustedMembersEntity>> getTrustedMembers();

  Future<Either<Failure, BeneficiaryMembersEntity>> geBeneficiaryMembers();

  Future<Either<Failure, BeneficiaryMembersEntity>> deleteBeneficiaryMembers(
      String id);

  Future<Either<Failure, TrustedMembersEntity>> deleteTrustedMembers(String id);
}
