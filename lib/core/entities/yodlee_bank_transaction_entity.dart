import 'package:wedge/core/entities/value_entity.dart';

class YodleeBankTransactionEntity {
  final String sId;
  final dynamic aggregatorAccountId;
  final ValueEntity amount;
  final String baseType;
  final String category;
  final String id;
  final String transactionDate;

  YodleeBankTransactionEntity(
      {required this.sId,
      required this.aggregatorAccountId,
      required this.amount,
      required this.baseType,
      required this.category,
      required this.id,
      required this.transactionDate});
}
