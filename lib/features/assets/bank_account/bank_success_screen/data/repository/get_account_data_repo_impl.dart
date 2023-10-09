import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/asset_liability_onboarding_model.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/data/datasource/get_account_data_datasource.dart';
import 'package:wedge/features/assets/bank_account/bank_success_screen/domain/repository/get_account_data_repository.dart';

class GetAccountDataRepositoryImpl implements GetAccountDataRepository {
  final GetAccountDataSource dataSource;

  GetAccountDataRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, AssetLiabilityOnboardingListModel>> getAccountData(
      String instituteId) async {
    try {
      final result = await dataSource.getAccountData(instituteId);
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
