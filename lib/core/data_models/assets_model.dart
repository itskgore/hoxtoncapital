import 'package:wedge/core/data_models/cryptp_currency_model.dart';
import 'package:wedge/core/data_models/investment_model.dart';
import 'package:wedge/core/data_models/manual_bank_accounts_model.dart';
import 'package:wedge/core/data_models/pension_model.dart';
import 'package:wedge/core/data_models/property_model.dart';
import 'package:wedge/core/data_models/stocks_model.dart';
import 'package:wedge/core/data_models/vehicle_model.dart';
import 'package:wedge/core/entities/assets_entity.dart';

import 'asset_total_model.dart';
import 'other_assets_model.dart';
import 'value_model.dart';

class AssetsModel extends AssetsEntity {
  AssetsModel(
      {required this.bankAccounts,
      required this.otherAssets,
      required this.summary,
      required this.properties,
      required this.stocksBonds,
      required this.investments,
      required this.cryptoCurrencies,
      required this.pensions,
      required this.vehicles})
      : super(
            bankAccounts: bankAccounts,
            otherAssets: otherAssets,
            properties: properties,
            summary: summary,
            stocksBonds: stocksBonds,
            pensions: pensions,
            investments: investments,
            cryptoCurrencies: cryptoCurrencies,
            vehicles: vehicles);
  late final List<ManualBankAccountsModel> bankAccounts;
  final List<OtherAssetsModel> otherAssets;
  final List<PropertyModel> properties;
  final List<StocksBondsModel> stocksBonds;
  final List<InvestmentsModel> investments;
  final List<VehicleModel> vehicles;
  final List<PensionsModel> pensions;
  final List<CryptoCurrenciesModel> cryptoCurrencies;
  final AssetsSummaryModel summary;

  factory AssetsModel.fromJson(Map<String, dynamic> json) {
    return AssetsModel(
        bankAccounts: List.from(json['bankAccounts'] ?? {})
            .map((e) => ManualBankAccountsModel.fromJson(e))
            .toList(),
        cryptoCurrencies: List.from(json['cryptoCurrencies'] ?? {})
            .map((e) => CryptoCurrenciesModel.fromJson(e))
            .toList(),
        otherAssets: List.from(json['otherAssets'] ?? {})
            .map((e) => OtherAssetsModel.fromJson(e))
            .toList(),
        properties: List.from(json['properties'] ?? {})
            .map((e) => PropertyModel.fromJson(e))
            .toList(),
        stocksBonds: List.from(json['stocksBonds'] ?? {})
            .map((e) => StocksBondsModel.fromJson(e))
            .toList(),
        investments: List.from(json['investments'] ?? {})
            .map((e) => InvestmentsModel.fromJson(e))
            .toList(),
        vehicles: List.from(json['vehicles'] ?? {})
            .map((e) => VehicleModel.fromJson(e))
            .toList(),
        summary: AssetsSummaryModel.fromJson(json['summary'] ?? {}),
        pensions: json['pensions'] != null
            ? List.from(json['pensions'])
                .map((e) => PensionsModel.fromJson(e))
                .toList()
            : []);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bankAccounts'] = bankAccounts.map((e) => e.toJson()).toList();
    _data['otherAssets'] = otherAssets.map((e) => e.toJson()).toList();
    _data['properties'] = properties.map((e) => e.toJson()).toList();
    _data['stocksBonds'] = stocksBonds.map((e) => e.toJson()).toList();
    _data['cryptoCurrencies'] =
        cryptoCurrencies.map((e) => e.toJson()).toList();
    _data['investments'] = investments.map((e) => e.toJson()).toList();
    _data['vehicles'] = vehicles.map((e) => e.toJson()).toList();
    _data['summary'] = summary.toJson();
    _data['pensions'] = pensions.map((e) => e.toJson()).toList();
    return _data;
  }
}

class AssetsSummaryModel extends AssetSummaryEntity {
  AssetsSummaryModel(
      {required this.types,
      required this.countries,
      required this.bankAccounts,
      required this.properties,
      required this.otherAssets,
      required this.stocksBonds,
      required this.investments,
      required this.pensions,
      required this.cryptoCurrencies,
      required this.vehicles,
      required this.total})
      : super(
            types: types,
            countries: countries,
            bankAccounts: bankAccounts,
            otherAssets: otherAssets,
            properties: properties,
            stocksBonds: stocksBonds,
            investments: investments,
            total: total,
            pensions: pensions,
            cryptoCurrencies: cryptoCurrencies,
            vehicles: vehicles);
  late final int types;
  late final int countries;
  final AssetTotalModel bankAccounts;
  final AssetTotalModel otherAssets;
  final AssetTotalModel properties;
  final AssetTotalModel stocksBonds;
  final AssetTotalModel investments;
  final AssetTotalModel vehicles;
  final AssetTotalModel pensions;
  final AssetTotalModel cryptoCurrencies;
  final ValueModel total;

  factory AssetsSummaryModel.fromJson(Map<String, dynamic> json) {
    return AssetsSummaryModel(
        types: json['types'],
        countries: json['countries'],
        cryptoCurrencies: json['cryptoCurrencies'] != null
            ? AssetTotalModel.fromJson(json['cryptoCurrencies'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        bankAccounts: json['bankAccounts'] != null
            ? AssetTotalModel.fromJson(json['bankAccounts'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        otherAssets: json['otherAssets'] != null
            ? AssetTotalModel.fromJson(json['otherAssets'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        properties: json['properties'] != null
            ? AssetTotalModel.fromJson(json['properties'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        stocksBonds: json['stocksBonds'] != null
            ? AssetTotalModel.fromJson(json['stocksBonds'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        investments: json['investments'] != null
            ? AssetTotalModel.fromJson(json['investments'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        vehicles: json['vehicles'] != null
            ? AssetTotalModel.fromJson(json['vehicles'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        pensions: json['pensions'] != null
            ? AssetTotalModel.fromJson(json['pensions'])
            : AssetTotalModel(
                amount: 0,
                currency: "",
                count: 0,
                countryCount: 0,
                disconnectedAccountCount: 0),
        total: json['total'] != null
            ? ValueModel.fromJson(json['total'])
            : ValueModel(amount: 0, currency: ""));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['types'] = types;
    _data['countries'] = countries;
    _data['cryptoCurrencies'] = cryptoCurrencies;
    _data['bankAccounts'] = bankAccounts.toJson();
    _data['otherAssets'] = otherAssets.toJson();
    _data['properties'] = properties.toJson();
    _data['stocksBonds'] = stocksBonds.toJson();
    _data['investments'] = investments.toJson();
    _data['vehicles'] = vehicles.toJson();
    _data['total'] = total.toJson();
    _data['pensions'] = pensions.toJson();
    return _data;
  }
}

// class RentalIncomeModel extends RentalIncomeEntity {
//   final ValueModel monthlyRentalIncome;

//   RentalIncomeModel({required this.monthlyRentalIncome})
//       : super(monthlyRentalIncome: monthlyRentalIncome);

//   factory RentalIncomeModel.fromJson(Map<String, dynamic> json) {
//     return RentalIncomeModel(
//       monthlyRentalIncome: ValueModel.fromJson(json['monthlyRentalIncome']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final _data = <String, dynamic>{};
//     _data['monthlyRentalIncome'] = monthlyRentalIncome;
//     return _data;
//   }
// }
