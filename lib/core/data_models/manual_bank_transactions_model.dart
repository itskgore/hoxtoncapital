import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/manual_bank_transactions_entity.dart';

class ManualBankTransactionModel extends ManualBankTransactionEntity {
  final String sId;
  final ValueModel balance;
  final bool isDeleted;
  final String bankAccountId;
  final String pseudonym;
  final String id;
  final String createdAt;
  final String updatedAt;

  ManualBankTransactionModel(
      {required this.sId,
      required this.balance,
      required this.isDeleted,
      required this.bankAccountId,
      required this.pseudonym,
      required this.id,
      required this.createdAt,
      required this.updatedAt})
      : super(
            balance: balance,
            bankAccountId: bankAccountId,
            createdAt: createdAt,
            id: id,
            isDeleted: isDeleted,
            pseudonym: pseudonym,
            sId: sId,
            updatedAt: updatedAt);

  factory ManualBankTransactionModel.fromJson(Map<String, dynamic> json) {
    return ManualBankTransactionModel(
        balance: ValueModel.fromJson(json['balance'] ?? {}),
        bankAccountId: json['bankAccountId'] ?? "",
        createdAt: json['createdAt'] ?? "",
        id: json['id'] ?? "",
        isDeleted: json['isDeleted'] ?? false,
        pseudonym: json['pseudonym'] ?? "",
        sId: json['_id'] ?? "",
        updatedAt: json['updatedAt'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    if (balance != null) {
      data['balance'] = balance.toJson();
    }
    data['isDeleted'] = isDeleted;
    data['bankAccountId'] = bankAccountId;
    data['pseudonym'] = pseudonym;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
