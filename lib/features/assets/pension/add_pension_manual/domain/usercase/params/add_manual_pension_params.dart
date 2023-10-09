class AddManualPensionParams {
  late final String name;
  late final String id;
  late final String pensionType;
  late final String country;
  late final String source;
  late final String policyNumber;
  late final AnnualIncomeAfterRetirement annualIncomeAfterRetirement;
  late final AnnualIncomeAfterRetirement currentValue;
  late final AnnualIncomeAfterRetirement monthlyContributionAmount;
  late final AnnualIncomeAfterRetirement contributionTotalAmount;
  late final int retirementAge;
  late final num averageAnnualGrowthRate;

  AddManualPensionParams(
      {required this.name,
      required this.id,
      required this.pensionType,
      required this.country,
      required this.source,
      required this.policyNumber,
      required this.annualIncomeAfterRetirement,
      required this.monthlyContributionAmount,
      required this.contributionTotalAmount,
      required this.averageAnnualGrowthRate,
      required this.currentValue,
      required this.retirementAge});

  AddManualPensionParams.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'] ?? "";
    pensionType = json['pensionType'];
    country = json['country'];
    source = json['source'] ?? "";
    policyNumber = json['policyNumber'];
    if (json['annualIncomeAfterRetirement'] != null) {
      annualIncomeAfterRetirement = AnnualIncomeAfterRetirement.fromJson(
          json['annualIncomeAfterRetirement']);
    }
    // if (json['contributionTotalAmount'] != null) {
    //   contributionTotalAmount =
    //       AnnualIncomeAfterRetirement.fromJson(json['contributionTotalAmount']);
    // }
    if (json['monthlyContributionAmount'] != null) {
      monthlyContributionAmount = AnnualIncomeAfterRetirement.fromJson(
          json['monthlyContributionAmount']);
    }
    if (json['currentValue'] != null) {
      currentValue = AnnualIncomeAfterRetirement.fromJson(json['currentValue']);
    }
    retirementAge = int.parse(
        json['retirementAge'].toString().isEmpty ? "0" : json['retirementAge']);
    averageAnnualGrowthRate = double.parse(
        json['averageAnnualGrowthRate'].toString().isEmpty
            ? "0"
            : json['averageAnnualGrowthRate'] ?? "0");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    data['pensionType'] = pensionType;
    data['country'] = country;
    data['source'] = source;
    data['policyNumber'] = policyNumber;
    if (annualIncomeAfterRetirement != null) {
      data['annualIncomeAfterRetirement'] =
          annualIncomeAfterRetirement.toJson();
    } else {
      data['annualIncomeAfterRetirement'] = null;
    }
    if (currentValue != null) {
      data['currentValue'] = currentValue.toJson();
    }
    if (monthlyContributionAmount != null) {
      data['monthlyContributionAmount'] = monthlyContributionAmount.toJson();
    } else {
      data['monthlyContributionAmount'] = null;
    }
    if (contributionTotalAmount != null) {
      data['contributionTotalAmount'] = contributionTotalAmount.toJson();
    } else {
      data['contributionTotalAmount'] = null;
    }
    data['retirementAge'] = retirementAge;
    data['averageAnnualGrowthRate'] = averageAnnualGrowthRate;
    data.removeWhere((key, value) => key == "" || value == "");
    return data;
  }
}

class AnnualIncomeAfterRetirement {
  late final num amount;
  late final String currency;

  AnnualIncomeAfterRetirement({required this.amount, required this.currency});

  AnnualIncomeAfterRetirement.fromJson(Map<String, dynamic> json) {
    amount = double.parse(
        json['amount'].toString().isEmpty ? "0" : json['amount'] ?? "0");
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}
