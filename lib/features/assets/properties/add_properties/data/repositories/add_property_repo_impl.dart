import 'package:dartz/dartz.dart';
import 'package:wedge/core/entities/property_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/error/failures.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/assets_liabilities_data_source.dart';
import 'package:wedge/features/all_accounts_types/data/data_sources/local_assets_liab_data_source.dart';
import 'package:wedge/features/assets/properties/add_properties/data/data_sources/add_properties_data_source.dart';
import 'package:wedge/features/assets/properties/add_properties/domain/repositories/add_properties_repository.dart';

class AddPropertyRepositoryImpl implements AddPropertiesRepository {
  final AddPropertiesDataSource dataSource;
  final AssetsLiabilitiesdataSource assetsLiabilitiesDataSource;
  final LocalAssetsLiabilitiesDataSource localAssetsLiabilitiesDataSource;

  AddPropertyRepositoryImpl(
      {required this.dataSource,
      required this.assetsLiabilitiesDataSource,
      required this.localAssetsLiabilitiesDataSource});

  @override
  Future<Either<Failure, PropertyEntity>> addProperty(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages) async {
    // TODO: implement AddCustomAssets
    try {
      final verifiedUser = await dataSource.addProperties(
          id,
          name,
          country,
          purchasedValue,
          currentValue,
          hasRentalIncome,
          rentalIncome,
          hasMortgage,
          mortgages);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, PropertyEntity>> updateProperty(
      String id,
      String name,
      String country,
      ValueEntity purchasedValue,
      ValueEntity currentValue,
      bool hasRentalIncome,
      RentalIncomeEntity rentalIncome,
      bool hasMortgage,
      List<Map<String, dynamic>> mortgages) async {
    try {
      final verifiedUser = await dataSource.updateProperties(
          id,
          name,
          country,
          purchasedValue,
          currentValue,
          hasRentalIncome,
          rentalIncome,
          hasMortgage,
          mortgages);
      // Refresh Liabilities
      final result = await assetsLiabilitiesDataSource.getMainLiabilities();
      await localAssetsLiabilitiesDataSource.saveLiabilities(result);
      return Right(verifiedUser);
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
