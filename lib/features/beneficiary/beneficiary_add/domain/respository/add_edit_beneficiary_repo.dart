import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';

abstract class AddEditBeneficiaryRepo {
  Future<Either<Failure, BeneficiaryMembersEntity>> addBeneficiary(
      Map<String, dynamic> body);

  Future<Either<Failure, BeneficiaryMembersEntity>> editBeneficiary(
      Map<String, dynamic> body, String id);
}
