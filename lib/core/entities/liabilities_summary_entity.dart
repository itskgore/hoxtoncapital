import 'package:wedge/core/entities/asset_total_entity.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/entities/liabilities_total_summary_entity.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/entities/value_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';

class LiabilitiesSummaryEnitity {
  LiabilitiesSummaryEnitity({
    required this.types,
    required this.countries,
    required this.personalLoans,
    required this.creditCards,
    required this.mortgages,
    required this.vehicleLoans,
    required this.otherLiabilities,
    required this.total,
  });
  final int types;
  final int countries;
  final LiabilitiesTotalEntity personalLoans;
  final LiabilitiesTotalEntity creditCards;
  final LiabilitiesTotalEntity mortgages;
  final LiabilitiesTotalEntity vehicleLoans;
  final LiabilitiesTotalEntity otherLiabilities;
  final ValueEntity total;
}
