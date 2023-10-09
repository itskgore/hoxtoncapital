import 'package:wedge/core/data_models/credit_cards_model.dart';
import 'package:wedge/core/data_models/liabilities_summary_model.dart';
import 'package:wedge/core/data_models/mortgages_model.dart';
import 'package:wedge/core/data_models/other_liabilities_model.dart';
import 'package:wedge/core/data_models/personal_loan_model.dart';
import 'package:wedge/core/data_models/vehicle_loans_model.dart';
import 'package:wedge/core/entities/liabilities_entity.dart';

class LiabilitiesModel extends LiabilitiesEntity {
  LiabilitiesModel({
    required this.personalLoans,
    required this.creditCards,
    required this.mortgages,
    required this.vehicleLoans,
    required this.otherLiabilities,
    required this.summary,
  }) : super(
            creditCards: creditCards,
            mortgages: mortgages,
            otherLiabilities: otherLiabilities,
            personalLoans: personalLoans,
            summary: summary,
            vehicleLoans: vehicleLoans);

  late final List<PersonalLoanModel> personalLoans;
  late final List<CreditCardsModel> creditCards;
  late final List<Mortgages> mortgages;
  late final List<VehicleLoans> vehicleLoans;
  late final List<OtherLiabilities> otherLiabilities;
  late final LiabilitiesSummary summary;

  factory LiabilitiesModel.fromJson(Map<String, dynamic> json) {
    return LiabilitiesModel(
        creditCards: List.from(json['creditCards'] ?? {})
            .map((e) => CreditCardsModel.fromJson(e))
            .toList(),
        mortgages: List.from(json['mortgages'] ?? {})
            .map((e) => Mortgages.fromJson(e))
            .toList(),
        otherLiabilities: List.from(json['otherLiabilities'] ?? {})
            .map((e) => OtherLiabilities.fromJson(e))
            .toList(),
        personalLoans: List.from(json['personalLoans'] ?? {})
            .map((e) => PersonalLoanModel.fromJson(e))
            .toList(),
        vehicleLoans: List.from(json['vehicleLoans'] ?? {})
            .map((e) => VehicleLoans.fromJson(e))
            .toList(),
        summary: LiabilitiesSummary.fromJson(
          json['summary'] ?? {},
        ));
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['personalLoans'] = personalLoans.map((e) => e.toJson()).toList();
    _data['creditCards'] = creditCards.map((e) => e.toJson()).toList();
    _data['mortgages'] = mortgages.map((e) => e.toJson()).toList();
    _data['vehicleLoans'] = vehicleLoans.map((e) => e.toJson()).toList();
    _data['otherLiabilities'] =
        otherLiabilities.map((e) => e.toJson()).toList();
    _data['summary'] = summary.toJson();
    return _data;
  }
}
