import 'dart:convert';

import '../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';

class InvestmentPerformanceModel {
  InvestmentPerformanceModel({
    this.merge,
  });

  final Merge? merge;

  factory InvestmentPerformanceModel.fromRawJson(String str) =>
      InvestmentPerformanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InvestmentPerformanceModel.fromJson(Map<String, dynamic> json) =>
      InvestmentPerformanceModel(
        merge: json["merge"] == null ? null : Merge.fromJson(json["merge"]),
      );

  Map<String, dynamic> toJson() => {
        "merge": merge?.toJson(),
      };
}

class Merge {
  Merge({
    this.fi,
  });

  final Fi? fi;

  factory Merge.fromRawJson(String str) => Merge.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Merge.fromJson(Map<String, dynamic> json) => Merge(
        fi: json["fi"] == null ? null : Fi.fromJson(json["fi"]),
      );

  Map<String, dynamic> toJson() => {
        "fi": fi?.toJson(),
      };
}

class Fi {
  Fi({
    this.lastDayPerformanceSummary,
    this.lastDayPerformance,
    this.baseCurrency,
    this.summary,
    this.performance,
  });

  final String? baseCurrency;
  final List<Summary>? summary;
  final List<List<dynamic>>? performance;
  final LastDayPerformance? lastDayPerformanceSummary;
  final LastDayPerformance? lastDayPerformance;

  factory Fi.fromRawJson(String str) => Fi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fi.fromJson(Map<String, dynamic> json) => Fi(
        baseCurrency: json["baseCurrency"],
        summary: json["summary"] == null
            ? []
            : List<Summary>.from(
                json["summary"]!.map((x) => Summary.fromJson(x))),
        performance: json["performance"] == null
            ? []
            : List<List<dynamic>>.from(json["performance"]!
                .map((x) => List<dynamic>.from(x.map((x) => x)))),
        lastDayPerformanceSummary: LastDayPerformance.fromJson(
            json["lastDayPerformanceSummary"]?[0] ?? {}),
        lastDayPerformance:
            LastDayPerformance.fromJson(json["lastDayPerformance"]?[0] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "baseCurrency": baseCurrency,
        "summary": summary == null
            ? []
            : List<dynamic>.from(summary!.map((x) => x.toJson())),
        "performance": performance == null
            ? []
            : List<dynamic>.from(
                performance!.map((x) => List<dynamic>.from(x.map((x) => x)))),
        "lastDayPerformanceSummary": lastDayPerformanceSummary?.toJson(),
        "lastDayPerformance": lastDayPerformance?.toJson(),
      };
}

class Summary {
  Summary({
    this.id,
    this.name,
    this.country,
    this.type,
    this.source,
    this.externalReferenceId,
  });

  final String? id;
  final String? name;
  final String? country;
  final String? type;
  final String? source;
  final String? externalReferenceId;

  factory Summary.fromRawJson(String str) => Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        id: json["id"],
        name: json["name"],
        country: json["country"],
        type: json["type"],
        source: json["source"],
        externalReferenceId: json["externalReferenceId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "type": type,
        "source": source,
        "externalReferenceId": externalReferenceId,
      };
}
