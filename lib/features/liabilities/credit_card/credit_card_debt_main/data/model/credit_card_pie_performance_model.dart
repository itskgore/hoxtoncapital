import 'dart:convert';

class CreditCardPiePerformanceModel {
  String? category;
  double? value;

  CreditCardPiePerformanceModel({this.category, this.value});

  factory CreditCardPiePerformanceModel.fromRawJson(String str) =>
      CreditCardPiePerformanceModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreditCardPiePerformanceModel.fromJson(Map<String, dynamic> json) =>
      CreditCardPiePerformanceModel(
        category: json["category"],
        value: json["value"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "value": value,
      };
}
