import 'package:dartz/dartz.dart';
import 'package:wedge/core/data_models/asset_liability_onboarding_model.dart';
import 'package:wedge/core/error/failures.dart';

abstract class GetAccountDataRepository {
  Future<Either<Failure, AssetLiabilityOnboardingListModel>> getAccountData(
      String instituteId);
}
