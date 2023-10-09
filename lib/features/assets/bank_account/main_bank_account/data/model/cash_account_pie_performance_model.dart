import 'dart:convert';

class CashAccountPiePerformanceModel {
  String? category;
  double? value;

  CashAccountPiePerformanceModel({
    this.category,
    this.value,
  });

  factory CashAccountPiePerformanceModel.fromRawJson(String str) =>
      CashAccountPiePerformanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CashAccountPiePerformanceModel.fromJson(Map<String, dynamic> json) =>
      CashAccountPiePerformanceModel(
        category: json["category"],
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "value": value,
      };
}
