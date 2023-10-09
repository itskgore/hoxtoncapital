import 'package:wedge/core/data_models/liabilities_total_model.dart';
import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/liabilities_summary_entity.dart';

class LiabilitiesSummary extends LiabilitiesSummaryEnitity {
  LiabilitiesSummary({
    required this.types,
    required this.countries,
    required this.personalLoans,
    required this.creditCards,
    required this.mortgages,
    required this.vehicleLoans,
    required this.otherLiabilities,
    required this.total,
  }) : super(
            countries: countries,
            creditCards: creditCards,
            mortgages: mortgages,
            otherLiabilities: otherLiabilities,
            personalLoans: personalLoans,
            total: total,
            types: types,
            vehicleLoans: vehicleLoans);
  late final int types;
  late final int countries;
  late final LiabilitiesTotalModel personalLoans;
  late final LiabilitiesTotalModel creditCards;
  late final LiabilitiesTotalModel mortgages;
  late final LiabilitiesTotalModel vehicleLoans;
  late final LiabilitiesTotalModel otherLiabilities;
  late final ValueModel total;

  factory LiabilitiesSummary.fromJson(Map<String, dynamic> json) {
    return LiabilitiesSummary(
      countries: json['countries'] ?? 0,
      creditCards: LiabilitiesTotalModel.fromJson(json['creditCards']),
      mortgages: LiabilitiesTotalModel.fromJson(json['mortgages']),
      otherLiabilities:
          LiabilitiesTotalModel.fromJson(json['otherLiabilities']),
      total: ValueModel.fromJson(json['total'] ?? {}),
      types: json['types'] ?? 0,
      personalLoans: LiabilitiesTotalModel.fromJson(json['personalLoans']),
      vehicleLoans: LiabilitiesTotalModel.fromJson(json['vehicleLoans']),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['types'] = types;
    _data['countries'] = countries;
    _data['personalLoans'] = personalLoans.toJson();
    _data['creditCards'] = creditCards.toJson();
    _data['mortgages'] = mortgages.toJson();
    _data['vehicleLoans'] = vehicleLoans.toJson();
    _data['otherLiabilities'] = otherLiabilities.toJson();
    _data['total'] = total.toJson();
    return _data;
  }
}
