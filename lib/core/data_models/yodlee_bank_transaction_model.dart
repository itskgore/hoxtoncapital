import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/yodlee_bank_transaction_entity.dart';

class YodleeBankTransactionModel extends YodleeBankTransactionEntity {
  static Map<String, dynamic> summary = {};
  static Map<String, dynamic> cursor = {};

  final String sId;
  final dynamic aggregatorAccountId;
  final ValueModel amount;
  final String baseType;
  final String category;
  final String id;
  final String transactionDate;

  YodleeBankTransactionModel(
      {required this.sId,
      required this.aggregatorAccountId,
      required this.amount,
      required this.baseType,
      required this.category,
      required this.id,
      required this.transactionDate})
      : super(
            aggregatorAccountId: aggregatorAccountId,
            amount: amount,
            baseType: baseType,
            category: category,
            id: id,
            sId: sId,
            transactionDate: transactionDate);

  factory YodleeBankTransactionModel.fromJson(Map<String, dynamic> json) {
    return YodleeBankTransactionModel(
        aggregatorAccountId: json['aggregatorAccountId'] ?? 0,
        amount: ValueModel.fromJson(json['amount'] ?? {}),
        baseType: json['baseType'] ?? "",
        category: json['category'] ?? "",
        id: json['id'] ?? "",
        sId: json['_id'] ?? "",
        transactionDate: json['date'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['aggregatorAccountId'] = aggregatorAccountId;
    if (amount != null) {
      data['amount'] = amount.toJson();
    }
    data['baseType'] = baseType;
    data['category'] = category;
    data['id'] = id;
    data['transactionDate'] = transactionDate;
    return data;
  }
}
