import 'package:wedge/core/data_models/pension_model.dart';
import 'package:wedge/features/assets/bank_account/userdata_summery/domain/entities/hoxton_summery_entity.dart';

class HoxtonSummeryModel extends HoxtonUserDataSUmmeryEntity {
  HoxtonSummeryModel({
    required this.summary,
    required this.pensions,
    required this.investments,
  }) : super(summary: summary, investments: investments, pensions: pensions);
  final Summary summary;
  final List<PensionsModel> pensions;
  final List<Investments> investments;

  factory HoxtonSummeryModel.fromJson(Map<String, dynamic> json) {
    return HoxtonSummeryModel(
        summary: Summary.fromJson(json['summary']),
        pensions: List.from(json['pensions'])
            .map((e) => PensionsModel.fromJson(e))
            .toList(),
        investments: List.from(json['investments'])
            .map((e) => Investments.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['summary'] = summary.toJson();
    data['pensions'] = pensions.map((e) => e.toJson()).toList();
    data['investments'] = investments.map((e) => e.toJson()).toList();
    return data;
  }
}

class Summary extends SummaryEntity {
  final Total total;
  final Total pensions;
  final Total investments;

  Summary({
    required this.total,
    required this.pensions,
    required this.investments,
  }) : super(total: total, pensions: pensions, investments: investments);

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
        total: Total.fromJson(json['total']),
        pensions: Total.fromJson(json['pensions']),
        investments: Total.fromJson(json['investments']));
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['total'] = total.toJson();
    data['pensions'] = pensions.toJson();
    data['investments'] = investments.toJson();
    return data;
  }
}

class Total extends TotalWithCurrencyEntity {
  final String currency;
  final num amount;

  Total({
    required this.currency,
    required this.amount,
  }) : super(currency: currency, amount: amount);

  factory Total.fromJson(Map<String, dynamic> json) {
    return Total(currency: json['currency'], amount: json['amount']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['currency'] = currency;
    data['amount'] = amount;
    return data;
  }
}

class Investments extends InvestmentsEntity {
  Investments({
    required this.id,
    required this.name,
    required this.policyNumber,
    required this.country,
    required this.source,
    required this.initialValue,
    required this.currentValue,
  }) : super(
          id: id,
          name: name,
          policyNumber: policyNumber,
          country: country,
          source: source,
          initialValue: initialValue,
          currentValue: currentValue,
        );

  final String id;
  final String name;
  final String policyNumber;
  final String country;
  final String source;
  final Total initialValue;
  final Total currentValue;

  factory Investments.fromJson(Map<String, dynamic> json) {
    return Investments(
      id: json['id'],
      name: json['name'],
      policyNumber: json['policyNumber'] ?? "",
      country: json['country'],
      source: json['source'] ?? "",
      initialValue: Total.fromJson(json['initialValue']),
      currentValue: Total.fromJson(json['currentValue']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['policyNumber'] = policyNumber;
    data['country'] = country;
    data['source'] = source;
    data['InitialValue'] = initialValue.toJson();
    data['currentValue'] = currentValue.toJson();

    return data;
  }
}
