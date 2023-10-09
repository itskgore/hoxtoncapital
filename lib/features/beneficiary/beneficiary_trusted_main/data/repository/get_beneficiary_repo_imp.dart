import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/beneficiary_member_entity.dart';
import 'package:wedge/core/entities/trusted_member_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/data/datasource/remote_get_beneficiary_datasource.dart';
import 'package:wedge/features/beneficiary/beneficiary_trusted_main/domain/repository/get_beneficiary_repo.dart';

class GetBeneficiaryRepoImp extends GetBeneficiaryRepo {
  RemoteGetBeneficiaryDataSource remoteGetBeneficiaryDataSource;

  GetBeneficiaryRepoImp({required this.remoteGetBeneficiaryDataSource});

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>>
      geBeneficiaryMembers() async {
    try {
      BeneficiaryMembersEntity data =
          await remoteGetBeneficiaryDataSource.getBeneficiaryMember();
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TrustedMembersEntity>> getTrustedMembers() async {
    try {
      TrustedMembersEntity data =
          await remoteGetBeneficiaryDataSource.getTrustedMember();
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, BeneficiaryMembersEntity>> deleteBeneficiaryMembers(
      String id) async {
    try {
      BeneficiaryMembersEntity data =
          await remoteGetBeneficiaryDataSource.deleteBeneficiaryMember(id);
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TrustedMembersEntity>> deleteTrustedMembers(
      String id) async {
    try {
      TrustedMembersEntity data =
          await remoteGetBeneficiaryDataSource.deleteTrustedMember(id);
      return Right(data);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
