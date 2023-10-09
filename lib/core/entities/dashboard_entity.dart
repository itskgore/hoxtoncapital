import '../data_models/aggregator_model.dart';
import '../data_models/dashboard_model.dart';

class DashboardDataEntity {
  String name;
  Dashboard data;
  List<List<dynamic>> cumulativeMonthlyCashFlow;

  DashboardDataEntity({
    required this.name,
    required this.data,
    required this.cumulativeMonthlyCashFlow,
  });
}

class DashboardEntity {
  final BankAccountsEntity bankAccounts;
  final InvestmentsEntity investments;
  final InvestmentsEntity pensions;
  final AssetSummaryEntity assetSummary;
  final AssetSummaryEntity liabilitySummary;
  final String baseCurrency;
  final String baseCurrencySymbol;
  final List<PerformacesEntity> performaces;
  final CashflowEntity cashflow;
  final num currentNetWorth;
  final String currentMonth;
  final String currentYear;
  final String asAt;
  DashboardEntity(
      {required this.bankAccounts,
      required this.investments,
      required this.pensions,
      required this.assetSummary,
      required this.liabilitySummary,
      required this.baseCurrency,
      required this.baseCurrencySymbol,
      required this.performaces,
      required this.cashflow,
      required this.currentNetWorth,
      required this.currentMonth,
      required this.currentYear,
      required this.asAt});
}

class BankAccountsEntity {
  final num totalCashBalance;
  final int linkedAccounts;
  final List<DetailsEntity> details;

  BankAccountsEntity(
      {required this.totalCashBalance,
      required this.linkedAccounts,
      required this.details});
}

class DetailsEntity {
  String id;
  String name;
  String country;
  String currency;
  num balance;
  String source;
  String accountNumber;
  String bankLogo;
  AggregatorModel? aggregator;
  DetailsEntity(
      {required this.id,
      required this.name,
      required this.accountNumber,
      required this.bankLogo,
      required this.country,
      required this.currency,
      required this.balance,
      required this.source,
      this.aggregator});
}

class InvestmentsEntity {
  num totalValue;
  List<DetailsEntity> details;

  InvestmentsEntity({required this.totalValue, required this.details});
}

class AssetSummaryEntity {
  num countries;
  num types;
  num value;

  AssetSummaryEntity(
      {required this.countries, required this.types, required this.value});
}

class PerformacesEntity {
  int date;
  num networth;
  num assetsTotal;
  num assetsCount;
  num liabilitiesTotal;
  num liabilitiesCount;
  num inflow;
  num outflow;
  num totalInvestmentValue;
  num totalPensionsValue;

  PerformacesEntity(
      {required this.date,
      required this.networth,
      required this.assetsTotal,
      required this.assetsCount,
      required this.liabilitiesTotal,
      required this.liabilitiesCount,
      required this.inflow,
      required this.outflow,
      required this.totalInvestmentValue,
      required this.totalPensionsValue});
}

class CashflowEntity {
  num inflowMTD;
  num outflowMTD;
  num inflowYTD;
  num outflowYTD;
  num totalInflow;
  num totalOutflow;

  CashflowEntity(
      {required this.inflowMTD,
      required this.outflowMTD,
      required this.inflowYTD,
      required this.outflowYTD,
      required this.totalInflow,
      required this.totalOutflow});
}
