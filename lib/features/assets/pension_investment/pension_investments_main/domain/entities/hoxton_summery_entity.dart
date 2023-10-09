import 'package:equatable/equatable.dart';
import 'package:wedge/core/entities/pension_entity.dart';

class HoxtonUserDataSUmmeryEntity extends Equatable {
  final SummaryEntity summary;
  final List<PensionsEntity> pensions;
  final List<InvestmentsEntity> investments;

  HoxtonUserDataSUmmeryEntity({
    required this.summary,
    required this.pensions,
    required this.investments,
  });

  @override
  List<Object> get props => [summary, pensions, investments];
}

class SummaryEntity {
  TotalWithCurrencyEntity total;
  TotalWithCurrencyEntity pensions;
  TotalWithCurrencyEntity investments;

  SummaryEntity(
      {required this.total, required this.pensions, required this.investments});
}

class InvestmentsEntity {
  String id;
  String name;
  String policyNumber;
  String country;
  String source;
  TotalWithCurrencyEntity initialValue;
  TotalWithCurrencyEntity currentValue;

  InvestmentsEntity({
    required this.id,
    required this.name,
    required this.policyNumber,
    required this.country,
    required this.source,
    required this.initialValue,
    required this.currentValue,
  });
}

class TotalWithCurrencyEntity {
  final int amount;
  final String currency;

  TotalWithCurrencyEntity({required this.amount, required this.currency});
}
