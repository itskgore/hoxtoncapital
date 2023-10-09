import 'dart:core';

import 'package:wedge/core/entities/cryptp_currency_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/entities/vehicle_entity.dart';

import 'asset_total_entity.dart';
import 'investment_entity.dart';
import 'manual_bank_accounts_entity.dart';
import 'other_assets.dart';
import 'property_entity.dart';
import 'stocks_entity.dart';

// import 'package:meta/meta.dart';

class AssetsEntity {
  AssetsEntity({
    required this.bankAccounts,
    required this.otherAssets,
    required this.properties,
    required this.stocksBonds,
    required this.investments,
    required this.vehicles,
    required this.cryptoCurrencies,
    required this.pensions,
    required this.summary,
  });
  final List<ManualBankAccountsEntity> bankAccounts;
  final List<OtherAssetsEntity> otherAssets;
  final List<CryptoCurrenciesEntity> cryptoCurrencies;
  final List<PropertyEntity> properties;
  final List<StocksAndBondsEntity> stocksBonds;
  final List<InvestmentEntity> investments;
  final List<VehicleEntity> vehicles;
  final List<PensionsEntity> pensions;
  final AssetSummaryEntity summary;

  List<Object> get props => [bankAccounts, otherAssets, summary, stocksBonds];
}

class AssetSummaryEntity {
  AssetSummaryEntity(
      {required this.types,
      required this.countries,
      required this.bankAccounts,
      required this.properties,
      required this.otherAssets,
      required this.stocksBonds,
      required this.investments,
      required this.cryptoCurrencies,
      required this.vehicles,
      required this.pensions,
      required this.total});
  late final int types;
  late final int countries;
  late final AssetTotalEntity bankAccounts;
  late final AssetTotalEntity otherAssets;
  late final AssetTotalEntity properties;
  late final AssetTotalEntity stocksBonds;
  late final AssetTotalEntity investments;
  late final AssetTotalEntity vehicles;
  late final AssetTotalEntity pensions;
  late final AssetTotalEntity cryptoCurrencies;
  late final ValueEntity total;

  List<Object> get props => [
        types,
        countries,
        bankAccounts,
        otherAssets,
        properties,
        stocksBonds,
        cryptoCurrencies
      ];
}

class RentalIncomeEntity {
  late ValueEntity monthlyRentalIncome;
  RentalIncomeEntity({required this.monthlyRentalIncome});
  List<Object> get props => [monthlyRentalIncome];
}
