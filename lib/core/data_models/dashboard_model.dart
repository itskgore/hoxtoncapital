import 'package:wedge/core/entities/dashboard_entity.dart';

import 'aggregator_model.dart';

class DashboardDataModel extends DashboardDataEntity {
  String name;
  Dashboard data;
  List<List<dynamic>> cumulativeMonthlyCashFlow;

  DashboardDataModel({
    required this.name,
    required this.data,
    required this.cumulativeMonthlyCashFlow,
  }) : super(
            name: name,
            data: data,
            cumulativeMonthlyCashFlow: cumulativeMonthlyCashFlow);

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
        name: json["name"] ?? "",
        data: Dashboard.fromJson(json["data"]),
        cumulativeMonthlyCashFlow: List<List<dynamic>>.from(
            json["CumulativeMonthlyCashFlow"]
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
      );

  Map<String, dynamic> toJson() => {
        "name": name ?? "",
        "data": data.toJson(),
        "CumulativeMonthlyCashFlow": List<dynamic>.from(
            cumulativeMonthlyCashFlow
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
      };
}

class Dashboard extends DashboardEntity {
  final BankAccounts bankAccounts;
  final Investments investments;
  final Investments pensions;
  final AssetSummary assetSummary;
  final AssetSummary liabilitySummary;
  final String baseCurrency;
  final String baseCurrencySymbol;
  final List<Performances> performaces;
  final Cashflow cashflow;
  final num currentNetWorth;
  final String currentMonth;
  final String currentYear;
  final String asAt;
  Dashboard(
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
      required this.asAt})
      : super(
            asAt: asAt,
            performaces: performaces,
            pensions: pensions,
            assetSummary: assetSummary,
            bankAccounts: bankAccounts,
            baseCurrency: baseCurrency,
            baseCurrencySymbol: baseCurrencySymbol,
            cashflow: cashflow,
            currentMonth: currentMonth,
            currentNetWorth: currentNetWorth,
            currentYear: currentYear,
            investments: investments,
            liabilitySummary: liabilitySummary);

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    // manipulate Performance
    List<Map<String, dynamic>> performanceJson = [];
    json['performance'].removeAt(0);
    List<dynamic> data = json['performance'];
    data.forEach((e) {
      performanceJson.add({
        "date": e[0],
        "networth": e[1],
        "assetsTotal": e[2],
        "assetsCount": e[3],
        "liabilitiesTotal": e[4],
        "liabilitiesCount": e[5],
        "inflow": e[6],
        "outflow": e[7],
        "totalInvestmentValue": e[8],
        "totalPensionsValue": e[9],
      });
    });
    json['performance'].clear();
    json['performance'] = performanceJson;
    return Dashboard(
        bankAccounts: BankAccounts.fromJson(json['bankAccounts'] ?? {}),
        investments: Investments.fromJson(json['investments'] ?? {}),
        pensions: Investments.fromJson(json['pensions'] ?? {}),
        assetSummary: AssetSummary.fromJson(json['assetSummary'] ?? {}),
        liabilitySummary: AssetSummary.fromJson(json['liabilitySummary'] ?? {}),
        baseCurrency: json['baseCurrency'] ?? "",
        baseCurrencySymbol: json['baseCurrencySymbol'] ?? "",
        performaces: List.from(json['performance'] ?? [])
            .map((e) => Performances.fromJson(e))
            .toList(),
        cashflow: Cashflow.fromJson(json['cashflow'] ?? {}),
        currentNetWorth: json['currentNetWorth'] ?? 0,
        currentMonth: json['currentMonth'] ?? 0,
        currentYear: json['currentYear'] ?? 0,
        asAt: json['asAt'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bankAccounts'] = bankAccounts.toJson();
    data['investments'] = investments.toJson();
    data['pensions'] = pensions.toJson();
    data['assetSummary'] = assetSummary.toJson();
    data['liabilitySummary'] = liabilitySummary.toJson();
    data['baseCurrency'] = baseCurrency;
    data['baseCurrencySymbol'] = baseCurrencySymbol;
    data['performaces'] = performaces.map((v) => v.toJson()).toList();
    data['cashflow'] = cashflow.toJson();
    data['currentNetWorth'] = currentNetWorth;
    data['currentMonth'] = currentMonth;
    data['currentYear'] = currentYear;
    data['asAt'] = asAt;
    return data;
  }
}

class BankAccounts extends BankAccountsEntity {
  final num totalCashBalance;
  final int linkedAccounts;
  final List<Details> details;

  BankAccounts(
      {required this.totalCashBalance,
      required this.linkedAccounts,
      required this.details})
      : super(
            details: details,
            linkedAccounts: linkedAccounts,
            totalCashBalance: totalCashBalance);

  factory BankAccounts.fromJson(Map<String, dynamic> json) {
    return BankAccounts(
        totalCashBalance: json['totalCashBalance'] ?? 0,
        linkedAccounts: json['linkedAccounts'] ?? 0,
        details: List.from(json['details'] ?? [])
            .map((e) => Details.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalCashBalance'] = totalCashBalance;
    data['linkedAccounts'] = linkedAccounts;
    data['details'] = details.map((v) => v.toJson()).toList();
    return data;
  }
}

class Details extends DetailsEntity {
  String id;
  String name;
  String country;
  String currency;
  num balance;
  String source;
  String accountNumber;
  String bankLogo;
  AggregatorModel? aggregator;

  Details({
    required this.id,
    required this.name,
    required this.country,
    required this.accountNumber,
    required this.bankLogo,
    required this.currency,
    required this.balance,
    required this.source,
    this.aggregator,
  }) : super(
          balance: balance,
          country: country,
          bankLogo: bankLogo,
          accountNumber: accountNumber,
          currency: currency,
          id: id,
          name: name,
          source: source,
          aggregator: aggregator,
        );

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
        id: json['id'] ?? "",
        bankLogo: json['bankLogo'] ?? "",
        accountNumber: json['accountNumber'] ?? "",
        name: json['name'] ?? "",
        country: json['country'] ?? "",
        currency: json['currency'] ?? "",
        balance: json['balance'] ?? 0,
        aggregator: AggregatorModel.fromJson(json["aggregator"] ?? {}),
        source: json['source'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['accountNumber'] = accountNumber;
    data['bankLogo'] = bankLogo;
    data['country'] = country;
    data['currency'] = currency;
    data['balance'] = balance;
    data['source'] = source;
    data['aggregator'] = aggregator?.toJson();
    return data;
  }
}

class Investments extends InvestmentsEntity {
  final num totalValue;
  final List<Details> details;

  Investments({required this.totalValue, required this.details})
      : super(details: details, totalValue: totalValue);

  factory Investments.fromJson(Map<String, dynamic> json) {
    return Investments(
        totalValue: json['totalValue'] ?? 0,
        details: List.from(json['details'] ?? [])
            .map((e) => Details.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalValue'] = totalValue;
    data['details'] = details.map((v) => v.toJson()).toList();
    return data;
  }
}

class AssetSummary extends AssetSummaryEntity {
  num countries;
  num types;
  num value;

  AssetSummary(
      {required this.countries, required this.types, required this.value})
      : super(countries: countries, types: types, value: value);

  factory AssetSummary.fromJson(Map<String, dynamic> json) {
    return AssetSummary(
        countries: json['countries'] ?? "",
        types: json['types'] ?? 0,
        value: json['value'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['countries'] = countries;
    data['types'] = types;
    data['value'] = value;
    return data;
  }
}

class Performances extends PerformacesEntity {
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

  Performances(
      {required this.date,
      required this.networth,
      required this.assetsTotal,
      required this.assetsCount,
      required this.liabilitiesTotal,
      required this.liabilitiesCount,
      required this.inflow,
      required this.outflow,
      required this.totalInvestmentValue,
      required this.totalPensionsValue})
      : super(
            assetsCount: assetsCount,
            assetsTotal: assetsTotal,
            date: date,
            inflow: inflow,
            liabilitiesCount: liabilitiesCount,
            liabilitiesTotal: liabilitiesTotal,
            networth: networth,
            outflow: outflow,
            totalInvestmentValue: totalInvestmentValue,
            totalPensionsValue: totalPensionsValue);
//Performances
  factory Performances.fromJson(Map<String, dynamic> json) {
    return Performances(
        date: json['date'] ?? 0,
        networth: json['networth'] ?? 0,
        assetsTotal: json['assetsTotal'] ?? 0,
        assetsCount: json['assetsCount'] ?? 0,
        liabilitiesTotal: json['liabilitiesTotal'] ?? 0,
        liabilitiesCount: json['liabilitiesCount'] ?? 0,
        inflow: json['inflow'] ?? 0,
        outflow: json['outflow'] ?? 0,
        totalInvestmentValue: json['totalInvestmentValue'] ?? 0,
        totalPensionsValue: json['totalPensionsValue'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['networth'] = networth;
    data['assetsTotal'] = assetsTotal;
    data['assetsCount'] = assetsCount;
    data['liabilitiesTotal'] = liabilitiesTotal;
    data['liabilitiesCount'] = liabilitiesCount;
    data['inflow'] = inflow;
    data['outflow'] = outflow;
    data['totalInvestmentValue'] = totalInvestmentValue;
    data['totalPensionsValue'] = totalPensionsValue;
    return data;
  }
}

class Cashflow extends CashflowEntity {
  num inflowMTD;
  num outflowMTD;
  num inflowYTD;
  num outflowYTD;
  num totalInflow;
  num totalOutflow;

  Cashflow(
      {required this.inflowMTD,
      required this.outflowMTD,
      required this.inflowYTD,
      required this.outflowYTD,
      required this.totalInflow,
      required this.totalOutflow})
      : super(
            inflowMTD: inflowMTD,
            inflowYTD: inflowYTD,
            outflowMTD: outflowMTD,
            outflowYTD: outflowYTD,
            totalInflow: totalInflow,
            totalOutflow: totalOutflow);

  factory Cashflow.fromJson(Map<String, dynamic> json) {
    return Cashflow(
        inflowMTD: json['inflowMTD'] ?? 0,
        outflowMTD: json['outflowMTD'] ?? 0,
        inflowYTD: json['inflowYTD'] ?? 0,
        outflowYTD: json['outflowYTD'] ?? 0,
        totalInflow: json['totalInflow'] ?? 0,
        totalOutflow: json['totalOutflow'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inflowMTD'] = inflowMTD;
    data['outflowMTD'] = outflowMTD;
    data['inflowYTD'] = inflowYTD;
    data['outflowYTD'] = outflowYTD;
    data['totalInflow'] = totalInflow;
    data['totalOutflow'] = totalOutflow;
    return data;
  }
}
