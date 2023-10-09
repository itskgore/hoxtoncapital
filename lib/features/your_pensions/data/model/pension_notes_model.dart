import 'dart:convert';

class PensionNotesModel {
  PensionNotesModel({
    this.id,
    this.source,
    this.name,
    this.pensionType,
    this.country,
    this.policyNumber,
    this.annualIncomeAfterRetirement,
    this.monthlyContributionAmount,
    this.currentValue,
    this.withdrawalValue,
    this.percentageGrowth,
    this.generalTransactionValue,
    this.notes,
    this.aggregator,
    this.isDeleted,
    this.averageAnnualGrowthRate,
    this.retirementAge,
    this.createdAt,
    this.updatedAt,
  });

  final String? id;
  final String? source;
  final String? name;
  final String? pensionType;
  final String? country;
  final String? policyNumber;
  final AnnualIncomeAfterRetirement? annualIncomeAfterRetirement;
  final AnnualIncomeAfterRetirement? monthlyContributionAmount;
  final AnnualIncomeAfterRetirement? currentValue;
  final AnnualIncomeAfterRetirement? withdrawalValue;
  final double? percentageGrowth;
  final AnnualIncomeAfterRetirement? generalTransactionValue;
  final String? notes;
  final Aggregator? aggregator;
  final bool? isDeleted;
  final int? averageAnnualGrowthRate;
  final int? retirementAge;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory PensionNotesModel.fromRawJson(String str) =>
      PensionNotesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PensionNotesModel.fromJson(Map<String, dynamic> json) =>
      PensionNotesModel(
        id: json["id"],
        source: json["source"],
        name: json["name"],
        pensionType: json["pensionType"],
        country: json["country"],
        policyNumber: json["policyNumber"],
        annualIncomeAfterRetirement: json["annualIncomeAfterRetirement"] == null
            ? null
            : AnnualIncomeAfterRetirement.fromJson(
                json["annualIncomeAfterRetirement"]),
        monthlyContributionAmount: json["monthlyContributionAmount"] == null
            ? null
            : AnnualIncomeAfterRetirement.fromJson(
                json["monthlyContributionAmount"]),
        currentValue: json["currentValue"] == null
            ? null
            : AnnualIncomeAfterRetirement.fromJson(json["currentValue"]),
        withdrawalValue: json["withdrawalValue"] == null
            ? null
            : AnnualIncomeAfterRetirement.fromJson(json["withdrawalValue"]),
        percentageGrowth: json["percentageGrowth"]?.toDouble(),
        generalTransactionValue: json["generalTransactionValue"] == null
            ? null
            : AnnualIncomeAfterRetirement.fromJson(
                json["generalTransactionValue"]),
        notes: json["notes"],
        aggregator: json["aggregator"] == null
            ? null
            : Aggregator.fromJson(json["aggregator"]),
        isDeleted: json["isDeleted"],
        averageAnnualGrowthRate: json["averageAnnualGrowthRate"],
        retirementAge: json["retirementAge"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "source": source,
        "name": name,
        "pensionType": pensionType,
        "country": country,
        "policyNumber": policyNumber,
        "annualIncomeAfterRetirement": annualIncomeAfterRetirement?.toJson(),
        "monthlyContributionAmount": monthlyContributionAmount?.toJson(),
        "currentValue": currentValue?.toJson(),
        "withdrawalValue": withdrawalValue?.toJson(),
        "percentageGrowth": percentageGrowth,
        "generalTransactionValue": generalTransactionValue?.toJson(),
        "notes": notes,
        "aggregator": aggregator?.toJson(),
        "isDeleted": isDeleted,
        "averageAnnualGrowthRate": averageAnnualGrowthRate,
        "retirementAge": retirementAge,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Aggregator {
  Aggregator();

  factory Aggregator.fromRawJson(String str) =>
      Aggregator.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Aggregator.fromJson(Map<String, dynamic> json) => Aggregator();

  Map<String, dynamic> toJson() => {};
}

class AnnualIncomeAfterRetirement {
  AnnualIncomeAfterRetirement({
    this.amount,
    this.currency,
  });

  final double? amount;
  final String? currency;

  factory AnnualIncomeAfterRetirement.fromRawJson(String str) =>
      AnnualIncomeAfterRetirement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnnualIncomeAfterRetirement.fromJson(Map<String, dynamic> json) =>
      AnnualIncomeAfterRetirement(
        amount: json["amount"]?.toDouble(),
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
      };
}
