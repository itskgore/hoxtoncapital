import 'package:wedge/core/entities/investment_entity.dart';
import 'package:wedge/core/entities/pension_entity.dart';

class InsightsEntity {
  InsightsEntity({
    required this.pensions,
    required this.investments,
  });
  final PensionsInsightParentEntity pensions;
  final InvestmentInsightParentEntity investments;
}
