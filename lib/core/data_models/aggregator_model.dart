import 'package:wedge/core/entities/aggregator_entity.dart';

class AggregatorModel extends AggregatorEntity {
  final dynamic customerId;
  final dynamic connectionId;
  final dynamic accountId;
  final String nature;
  final String consentExpireAt;
  final String? createdDate;
  final String? lastUpdatedDate;
  final dynamic lastUpdated;
  final Extra extra;
  final String status;
  final dynamic institutionId;
  final dynamic isRealTimeMFA;

  AggregatorModel(
      {required this.customerId,
      required this.connectionId,
      required this.accountId,
      required this.institutionId,
      required this.nature,
      this.lastUpdatedDate,
      this.createdDate,
      required this.consentExpireAt,
      required this.lastUpdated,
      required this.extra,
      required this.status,
      required this.isRealTimeMFA})
      : super(
            accountId: accountId,
            connectionId: connectionId,
            consentExpireAt: connectionId,
            institutionId: institutionId,
            customerId: customerId,
            extra: extra,
            lastUpdated: lastUpdated,
            lastUpdatedDate: lastUpdatedDate,
            createdDate: createdDate,
            nature: nature,
            status: status,
            isRealTimeMFA: isRealTimeMFA);

  factory AggregatorModel.fromJson(Map<String, dynamic> json) {
    return AggregatorModel(
        accountId: json['accountId'] ?? "",
        connectionId: json['connectionId'] ?? "",
        nature: json['nature'] ?? "",
        institutionId: json['institutionId'] ?? "",
        consentExpireAt: json['consentExpireAt'] ?? "",
        lastUpdated: json['lastUpdated'] ?? "",
        createdDate: json['createdDate'] ?? "",
        lastUpdatedDate: json['lastUpdatedDate'] ?? "",
        extra: Extra.fromJson(json['extra'] ?? {}),
        status: json['status'] ?? "",
        customerId: json['customerId'] ?? "",
        isRealTimeMFA: json['isRealTimeMFA'] ?? false);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = customerId;
    data['connectionId'] = connectionId;
    data['accountId'] = accountId;
    data['nature'] = nature;
    data['consentExpireAt'] = consentExpireAt;
    data['lastUpdated'] = lastUpdated;
    data['lastUpdatedDate'] = lastUpdatedDate;
    data['createdDate'] = createdDate;
    data['extra'] = extra.toJson();
    data['status'] = status;
    data['isRealTimeMFA'] = isRealTimeMFA;
    return data;
  }
}

class Extra extends ExtraEntity {
  final dynamic iban;
  final dynamic credit_limit;

  final dynamic swift;
  final dynamic status;
  final dynamic sortCode;
  final dynamic clientName;
  final dynamic accountName;
  final dynamic accountNumber;
  final num availableAmount;
  final TransactionsCount transactionsCount;
  final dynamic lastPostedTransactionId;
  final dynamic providerAccountId;

  Extra(
      {required this.iban,
      required this.credit_limit,
      required this.swift,
      required this.status,
      required this.sortCode,
      required this.clientName,
      required this.accountName,
      required this.accountNumber,
      required this.availableAmount,
      required this.transactionsCount,
      required this.lastPostedTransactionId,
      required this.providerAccountId})
      : super(
            accountName: accountName,
            accountNumber: accountNumber,
            availableAmount: availableAmount,
            clientName: clientName,
            iban: iban,
            credit_limit: credit_limit,
            lastPostedTransactionId: lastPostedTransactionId,
            sortCode: sortCode,
            status: status,
            swift: swift,
            transactionsCount: transactionsCount,
            providerAccountId: providerAccountId);

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
        iban: json['iban'] ?? "",
        credit_limit: json['credit_limit'] ?? "",
        swift: json['swift'] ?? "",
        status: json['status'] ?? "",
        sortCode: json['sort_code'] ?? "",
        clientName: json['client_name'] ?? "",
        accountName: json['account_name'] ?? "",
        accountNumber: json['account_number'] ?? "",
        availableAmount: json['available_amount'] ?? 0,
        transactionsCount:
            TransactionsCount.fromJson(json['transactions_count'] ?? {}),
        lastPostedTransactionId: json['last_posted_transaction_id'] ?? "",
        providerAccountId: json['providerAccountId'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iban'] = iban;
    data['credit_limit'] = credit_limit;
    data['swift'] = swift;
    data['status'] = status;
    data['sort_code'] = sortCode;
    data['client_name'] = clientName;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['available_amount'] = availableAmount;
    data['transactions_count'] = transactionsCount.toJson();
    data['last_posted_transaction_id'] = lastPostedTransactionId;
    data['providerAccountId'] = providerAccountId;
    return data;
  }
}

class TransactionsCount extends TransactionsCountEntity {
  final num posted;
  final num pending;

  TransactionsCount({required this.posted, required this.pending})
      : super(pending: pending, posted: posted);

  factory TransactionsCount.fromJson(Map<String, dynamic> json) {
    return TransactionsCount(
      pending: json['posted'] ?? 0,
      posted: json['pending'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['posted'] = posted;
    data['pending'] = pending;
    return data;
  }
}
