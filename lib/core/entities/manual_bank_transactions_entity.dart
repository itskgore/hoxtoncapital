import 'package:wedge/core/entities/value_entity.dart';

class ManualBankTransactionEntity {
  final String sId;
  final ValueEntity balance;
  final bool isDeleted;
  final String bankAccountId;
  final String pseudonym;
  final String id;
  final String createdAt;
  final String updatedAt;

  ManualBankTransactionEntity(
      {required this.sId,
      required this.balance,
      required this.isDeleted,
      required this.bankAccountId,
      required this.pseudonym,
      required this.id,
      required this.createdAt,
      required this.updatedAt});
}
