import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/data/datasource/remote_add_edit_beneficiary_datasource.dart';
import 'package:wedge/features/beneficiary/beneficiary_add/domain/respository/add_edit_beneficiary_repo.dart';

class AddEditBeneficaryRepoImp extends AddEditBeneficiaryRepo {
  final RemoteAddEditBeneficairyDataSource remoteAddEditBeneficairyDataSource;

  AddEditBeneficaryRepoImp({required this.remoteAddEditBeneficairyDataSource});

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>> addBeneficiary(
      Map<String, dynamic> body) async {
    try {
      final result =
          await remoteAddEditBeneficairyDataSource.addBeneficiaryMember(body);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>> editBeneficiary(
      Map<String, dynamic> body, String id) async {
    try {
      final result = await remoteAddEditBeneficairyDataSource
          .editBeneficiaryMember(body, id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
