import 'dart:convert';
import 'dart:developer';

import '../../../../../../core/common/line_performance_graph/data/model/line_performance_model.dart';

class StocksPerformanceModel {
  Merge? merge;

  StocksPerformanceModel({
    this.merge,
  });

  factory StocksPerformanceModel.fromRawJson(String str) =>
      StocksPerformanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StocksPerformanceModel.fromJson(Map<String, dynamic> json) =>
      StocksPerformanceModel(
        merge: json["merge"] == null ? null : Merge.fromJson(json["merge"]),
      );

  Map<String, dynamic> toJson() => {
        "merge": merge?.toJson(),
      };
}

class Merge {
  Fi? fi;

  Merge({
    this.fi,
  });

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
  String? baseCurrency;
  List<Summary>? summary;
  List<List<dynamic>>? performance;
  List<List<dynamic>>? performanceSummary;
  final LastDayPerformance? lastDayPerformanceSummary;
  final LastDayPerformance? lastDayPerformance;

  Fi({
    this.lastDayPerformanceSummary,
    this.lastDayPerformance,
    this.baseCurrency,
    this.summary,
    this.performance,
    this.performanceSummary,
  });

  factory Fi.fromRawJson(String str) => Fi.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Fi.fromJson(Map<String, dynamic> json) {
    log(json.keys.toString(), name: "Keys");
    return Fi(
      baseCurrency: json["baseCurrency"],
      summary: json["summary"] == null
          ? []
          : List<Summary>.from(
              json["summary"]?.map((x) => Summary.fromJson(x)) ?? []),
      performance: json["performance"] == null
          ? []
          : List<List<dynamic>>.from(json["performance"]
                  ?.map((x) => List<dynamic>.from(x.map((x) => x))) ??
              []),
      performanceSummary: json["performanceSummary"] == null
          ? []
          : List<List<dynamic>>.from(json["performanceSummary"]
                  .map((x) => List<dynamic>.from(x.map((x) => x))) ??
              []),
      lastDayPerformanceSummary: LastDayPerformance.fromJson(
          json["lastDayPerformanceSummary"]?[0] ?? {}),
      lastDayPerformance:
          LastDayPerformance.fromJson(json["lastDayPerformance"]?[0] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        "baseCurrency": baseCurrency,
        "summary": summary == null
            ? []
            : List<dynamic>.from(summary?.map((x) => x.toJson()) ?? []),
        "performance": performance == null
            ? []
            : List<dynamic>.from(
                performance?.map((x) => List<dynamic>.from(x.map((x) => x))) ??
                    []),
        "performanceSummary": performanceSummary == null
            ? []
            : List<dynamic>.from(performanceSummary
                    ?.map((x) => List<dynamic>.from(x.map((x) => x))) ??
                []),
        "lastDayPerformanceSummary": lastDayPerformanceSummary?.toJson(),
        "lastDayPerformance": lastDayPerformance?.toJson(),
      };
}

class Summary {
  String? id;
  String? name;
  String? country;
  String? type;
  String? source;
  var externalReferenceId;
  String? lookupType;
  String? lookupValue;

  Summary({
    this.id,
    this.name,
    this.country,
    this.type,
    this.source,
    this.externalReferenceId,
    this.lookupType,
    this.lookupValue,
  });

  factory Summary.fromRawJson(String str) => Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        id: json["id"],
        name: json["name"],
        country: json["country"],
        type: json["type"],
        source: json["source"],
        externalReferenceId: json["externalReferenceId"],
        lookupType: json["lookupType"],
        lookupValue: json["lookupValue"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country": country,
        "type": type,
        "source": source,
        "externalReferenceId": externalReferenceId,
        "lookupType": lookupType,
        "lookupValue": lookupValue,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
