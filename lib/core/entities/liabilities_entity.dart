import 'package:wedge/core/entities/credit_cards_entity.dart';
import 'package:wedge/core/entities/liabilities_summary_entity.dart';
import 'package:wedge/core/entities/mortgages_entity.dart';
import 'package:wedge/core/entities/other_liabilities_entity.dart';
import 'package:wedge/core/entities/personal_loan_entity.dart';
import 'package:wedge/core/entities/vehicles_loans_entity.dart';

class LiabilitiesEntity {
  LiabilitiesEntity({
    required this.personalLoans,
    required this.creditCards,
    required this.mortgages,
    required this.vehicleLoans,
    required this.otherLiabilities,
    required this.summary,
  });
  final List<PersonalLoanEntity> personalLoans;
  final List<CreditCardsEntity> creditCards;
  final List<MortgagesEntity> mortgages;
  final List<VehicleLoansEntity> vehicleLoans;
  final List<OtherLiabilitiesEntity> otherLiabilities;
  final LiabilitiesSummaryEnitity summary;
}
