import 'package:wedge/core/data_models/investment_model.dart';
import 'package:wedge/core/data_models/pension_model.dart';
import 'package:wedge/core/entities/insights_entity.dart';

class InsightsModel extends InsightsEntity {
  InsightsModel({
    required this.pensions,
    required this.investments,
  }) : super(
          pensions: pensions,
          investments: investments,
        );
  final PensionsInsightsParentModel pensions;
  final InvestmentInsightsParentModel investments;

  factory InsightsModel.fromJson(Map<String, dynamic> json) {
    return InsightsModel(
      pensions: PensionsInsightsParentModel.fromJson(
        json['pensions'] ?? {},
      ),
      investments: InvestmentInsightsParentModel.fromJson(
        json['investments'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['pensions'] = pensions;
    _data['investments'] = investments;
    return _data;
  }
}
