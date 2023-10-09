class AssetLiabilitiesChartEntity {
  final List<YearDataEntity> yearData;

  AssetLiabilitiesChartEntity({required this.yearData});
}

class YearDataEntity {
  final ChartDataEntity financialChartData;
  final ChartDataEntity holdingsChartData;

  YearDataEntity(
      {required this.financialChartData, required this.holdingsChartData});
}

class ChartDataEntity {
  final String baseCurrency;
  final List<ChartSummaryEntity> summary;
  final List<dynamic> performance;
  final List<dynamic> performanceSummary;

  ChartDataEntity(
      {required this.baseCurrency,
      required this.summary,
      required this.performanceSummary,
      required this.performance});
}

class ChartSummaryEntity {
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

  ChartSummaryEntity(
      {required this.id,
      required this.source,
      required this.name,
      required this.type,
      required this.country,
      required this.currency,
      required this.lookupType,
      required this.lookupValue,
      required this.externalReferenceId,
      required this.belongsTo});
}
