import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/tenant_model.dart';
import 'package:wedge/core/entities/user_account_data_entity.dart';
import 'package:wedge/core/entities/user_preferences_entity.dart';
import 'package:wedge/core/error/failures.dart';

import '../../domain/repository/user_account_repo.dart';
import '../../domain/usecase/params/edit_user_account_params.dart';
import '../datasource/remote_user_account_data.dart';

class UserAccountRepoImp implements UserAccountRepo {
  final RemoteUserAccountData remoteUserAccountData;

  UserAccountRepoImp({required this.remoteUserAccountData});

  @override
  Future<Either<Failure, UserAccountDataEntity>> getUserDetails() async {
    try {
      final result = await remoteUserAccountData.getUserDetails();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, UserAccountDataEntity>> editUserDetails(
      EditUserAccountParams params) async {
    try {
      final result =
          await remoteUserAccountData.editUserDetails(params.toJson());
      return Right(result);
    } on LargeImageFailure {
      return const Left(LargeImageFailure());
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> editUserPreferences(
      Map<String, dynamic> body, String id) async {
    try {
      final result = await remoteUserAccountData.editUserPreferences(body, id);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, UserPreferencesEntity>> getUserPreferences() async {
    try {
      final result = await remoteUserAccountData.getUserPrefences();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, TenantModel>> getTenant() async {
    try {
      final result = await remoteUserAccountData.getTenant();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
