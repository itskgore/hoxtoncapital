class AggregatorEntity {
  final dynamic customerId;
  final dynamic connectionId;
  final dynamic accountId;
  final String nature;
  final String consentExpireAt;
  final dynamic lastUpdated;
  final dynamic institutionId;
  final String? lastUpdatedDate;
  final String? createdDate;
  final dynamic isRealTimeMFA;
  ExtraEntity? extra;

  // final ExtraEntity extra;
  final String status;

  AggregatorEntity(
      {required this.customerId,
      required this.connectionId,
      required this.accountId,
      required this.nature,
      required this.consentExpireAt,
      required this.lastUpdated,
      required this.institutionId,
      this.createdDate,
      this.lastUpdatedDate,
      required this.extra,
      required this.status,
      required this.isRealTimeMFA});
}

class ExtraEntity {
  final dynamic iban;
  final dynamic credit_limit;
  final dynamic swift;
  final dynamic status;
  final dynamic sortCode;
  final dynamic clientName;
  final dynamic accountName;
  final dynamic accountNumber;
  final num availableAmount;
  final TransactionsCountEntity transactionsCount;
  final dynamic lastPostedTransactionId;
  // Getting below data from Notifications
  final dynamic providerAccountId;

  ExtraEntity(
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
      required this.providerAccountId});
}

class TransactionsCountEntity {
  final num posted;
  final num pending;

  TransactionsCountEntity({required this.posted, required this.pending});
}
