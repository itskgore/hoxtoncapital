import 'package:wedge/core/entities/asset_liabilities_charts_entity.dart';

class AssetLiabilitiesChartModel extends AssetLiabilitiesChartEntity {
  final List<YearDataModel> yearData;

  AssetLiabilitiesChartModel({required this.yearData})
      : super(yearData: yearData);

  factory AssetLiabilitiesChartModel.fromJson(Map<String, dynamic> json) {
    return AssetLiabilitiesChartModel(
      yearData: List.from(json['data'] ?? {})
          .map((e) => YearDataModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['yearData'] = yearData;
    return data;
  }
}

class YearDataModel extends YearDataEntity {
  final ChartDataModel financialChartData;
  final ChartDataModel holdingsChartData;

  YearDataModel(
      {required this.financialChartData, required this.holdingsChartData})
      : super(
            financialChartData: financialChartData,
            holdingsChartData: holdingsChartData);

  factory YearDataModel.fromJson(Map<String, dynamic> json) {
    // print(json);
    return YearDataModel(
      financialChartData: ChartDataModel.fromJson(json['fi'] ?? {}),
      holdingsChartData: ChartDataModel.fromJson(json['holdings'] ?? {}),
    );
  }
}

class ChartDataModel extends ChartDataEntity {
  final String baseCurrency;
  final List<ChartSummaryModel> summary;
  final List<dynamic> performance;
  final List<dynamic> performanceSummary;

  ChartDataModel(
      {required this.baseCurrency,
      required this.summary,
      required this.performanceSummary,
      required this.performance})
      : super(
            baseCurrency: baseCurrency,
            performance: performance,
            performanceSummary: performanceSummary,
            summary: summary);

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    // print(json);
    return ChartDataModel(
        baseCurrency: json['baseCurrency'] ?? "",
        summary: List.from(json['summary'] ?? {})
            .map((e) => ChartSummaryModel.fromJson(e))
            .toList(),
        performanceSummary: json['performanceSummary'] ?? [],
        performance: json['performance'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['baseCurrency'] = baseCurrency;
    data['summary'] = summary.map((v) => v.toJson()).toList();
    data['performance'] = performance;
    data['performanceSummary'] = performanceSummary;
    return data;
  }
}

class ChartSummaryModel extends ChartSummaryEntity {
  final String id;
  final String source;
  final String name;
  final String type;
  final String country;
  final String currency;
  final String lookupType;
  final String lookupValue;
  final String externalReferenceId;
  final String belongsTo;

  ChartSummaryModel(
      {required this.id,
      required this.source,
      required this.name,
      required this.type,
      required this.country,
      required this.currency,
      required this.lookupType,
      required this.lookupValue,
      required this.externalReferenceId,
      required this.belongsTo})
      : super(
            belongsTo: belongsTo,
            country: country,
            currency: currency,
            externalReferenceId: externalReferenceId,
            id: id,
            lookupType: lookupType,
            lookupValue: lookupValue,
            name: name,
            source: source,
            type: type);

  factory ChartSummaryModel.fromJson(Map<String, dynamic> json) {
    return ChartSummaryModel(
      belongsTo: json['belongsTo'] ?? "",
      country: json['country'] ?? "",
      currency: json['currency'] ?? "",
      externalReferenceId: json['externalReferenceId'].toString(),
      id: json['id'] ?? "",
      lookupType: json['lookupType'] ?? "",
      lookupValue: json['lookupValue'] ?? "",
      name: json['name'] ?? "",
      source: json['source'] ?? "",
      type: json['type'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['source'] = source;
    data['name'] = name;
    data['type'] = type;
    data['country'] = country;
    data['currency'] = currency;
    data['lookupType'] = lookupType;
    data['lookupValue'] = lookupValue;
    data['externalReferenceId'] = externalReferenceId;
    data['belongsTo'] = belongsTo;
    return data;
  }
}
