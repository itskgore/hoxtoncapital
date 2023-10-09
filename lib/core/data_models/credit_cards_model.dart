// import 'package:wedge/core/data_models/value_model.dart';
// import 'package:wedge/core/entities/credit_cards_entity.dart';

// class CreditCardsModel extends CreditCardsEntity {
//   CreditCardsModel({
//     required this.id,
//     required this.name,
//     required this.country,
//     required this.outstandingAmount,
//     required this.createdAt,
//     required this.updatedAt,
//   }) : super(
//             country: country,
//             createdAt: createdAt,
//             id: id,
//             name: name,
//             outstandingAmount: outstandingAmount,
//             updatedAt: updatedAt);
//   late final String id;
//   late final String name;
//   late final String country;
//   late final ValueModel outstandingAmount;
//   late final String createdAt;
//   late final String updatedAt;

//   factory CreditCardsModel.fromJson(Map<String, dynamic> json) {
//     return CreditCardsModel(
//       country: json['country'] ?? "",
//       createdAt: json['createdAt'] ?? "",
//       id: json['id'] ?? "",
//       name: json['name'] ?? "",
//       outstandingAmount: ValueModel.fromJson(json['outstandingAmount'] ?? {}),
//       updatedAt: json['updatedAt'] ?? "",
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final _data : <String, dynamic>{};
//     _data['id'] : id;
//     _data['name'] : name;
//     _data['country'] : country;
//     _data['outstandingAmount'] : outstandingAmount.toJson();
//     _data['createdAt'] : createdAt;
//     _data['updatedAt'] : updatedAt;
//     return _data;
//   }
// }

import 'package:wedge/core/data_models/aggregator_model.dart';
import 'package:wedge/core/data_models/value_model.dart';
import 'package:wedge/core/entities/credit_cards_entity.dart';

class CreditCardsModel extends CreditCardsEntity {
  CreditCardsModel({
    required this.id,
    required this.name,
    required this.country,
    required this.outstandingAmount,
    required this.createdAt,
    required this.updatedAt,
    this.aggregatorId,
    required this.aggregatorAccountNumber,
    required this.providerName,
    required this.accountType,
    required this.aggregatorProviderAccountId,
    required this.aggregatorProviderId,
    required this.amountDue,
    required this.currentAmount,
    required this.displayedName,
    required this.isDeleted,
    required this.lastPaymentAmount,
    required this.minimumAmountDue,
    required this.runningBalance,
    required this.totalCashLimit,
    required this.totalCreditLine,
    this.creditLimit,
    required this.source,
    required this.aggregatorLogo,
    required this.aggregator,
  }) : super(
            country: country,
            createdAt: createdAt,
            id: id,
            name: name,
            outstandingAmount: outstandingAmount,
            updatedAt: updatedAt,
            accountType: accountType,
            aggregator: aggregator,
            aggregatorAccountNumber: aggregatorAccountNumber,
            aggregatorId: aggregatorId,
            creditLimit: creditLimit,
            aggregatorLogo: aggregatorLogo,
            aggregatorProviderAccountId: aggregatorProviderAccountId,
            aggregatorProviderId: aggregatorProviderId,
            amountDue: amountDue,
            currentAmount: currentAmount,
            displayedName: displayedName,
            isDeleted: isDeleted,
            lastPaymentAmount: lastPaymentAmount,
            minimumAmountDue: minimumAmountDue,
            providerName: providerName,
            runningBalance: runningBalance,
            source: source,
            totalCashLimit: totalCashLimit,
            totalCreditLine: totalCreditLine);
  late final String id;
  late final String name;
  late final String country;
  late final ValueModel outstandingAmount;
  late final String createdAt;
  late final String updatedAt;
  late final dynamic aggregatorId;

  late final num aggregatorProviderAccountId;
  late final String providerName;
  late final String aggregatorAccountNumber;
  late final String aggregatorProviderId;
  late final String accountType;
  late final String displayedName;
  late final bool isDeleted;
  late final ValueModel currentAmount;
  late final ValueModel minimumAmountDue;
  late final ValueModel amountDue;
  late final ValueModel totalCashLimit;
  late final ValueModel runningBalance;
  late final ValueModel lastPaymentAmount;
  late final ValueModel totalCreditLine;
  final ValueModel? creditLimit;

  late final String aggregatorLogo;
  late final String source;
  final AggregatorModel? aggregator;

  factory CreditCardsModel.fromJson(Map<String, dynamic> json) {
    return CreditCardsModel(
      country: json['country'] ?? "",
      createdAt: json['createdAt'] ?? "",
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      aggregator: json['aggregator'] != null
          ? AggregatorModel.fromJson(json['aggregator'])
          : null,
      outstandingAmount: ValueModel.fromJson(json['outstandingAmount'] ?? {}),
      updatedAt: json['updatedAt'] ?? "",
      accountType: json['accountType'] ?? "",
      aggregatorId: json['aggregatorId'] ?? 0,
      aggregatorProviderAccountId: json['aggregatorProviderAccountId'] ?? 0,
      providerName: json['providerName'] ?? "",
      aggregatorAccountNumber: json['aggregatorAccountNumber'] ?? "",
      aggregatorProviderId: json['aggregatorProviderId'] ?? "",
      displayedName: json['displayedName'] ?? "",
      isDeleted: json['isDeleted'] ?? false,
      currentAmount: ValueModel.fromJson(json['currentAmount'] ?? {}),
      minimumAmountDue: ValueModel.fromJson(json['minimumAmountDue'] ?? {}),
      amountDue: ValueModel.fromJson(json['amountDue'] ?? {}),
      totalCashLimit: ValueModel.fromJson(json['totalCashLimit'] ?? {}),
      runningBalance: ValueModel.fromJson(json['runningBalance'] ?? {}),
      lastPaymentAmount: ValueModel.fromJson(json['lastPaymentAmount'] ?? {}),
      totalCreditLine: ValueModel.fromJson(json['totalCreditLine'] ?? {}),
      creditLimit: ValueModel.fromJson(json['creditLimit'] ?? {}),
      aggregatorLogo: json['aggregatorLogo'] ?? "",
      source: json['source'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aggregatorId'] = this.aggregatorId;

    data['aggregator'] = this.aggregator?.toJson();
    data['aggregatorProviderAccountId'] = this.aggregatorProviderAccountId;
    data['name'] = this.name;
    data['providerName'] = this.providerName;
    data['aggregatorAccountNumber'] = this.aggregatorAccountNumber;
    data['aggregatorProviderId'] = this.aggregatorProviderId;
    data['accountType'] = this.accountType;
    data['displayedName'] = this.displayedName;
    data['isDeleted'] = this.isDeleted;
    data['currentAmount'] = this.currentAmount.toJson();
    data['minimumAmountDue'] = this.minimumAmountDue.toJson();
    data['amountDue'] = this.amountDue.toJson();
    data['totalCashLimit'] = this.totalCashLimit.toJson();
    data['runningBalance'] = this.runningBalance.toJson();
    data['lastPaymentAmount'] = this.lastPaymentAmount.toJson();
    data['totalCreditLine'] = this.totalCreditLine.toJson();
    data['creditLimit'] = this.creditLimit?.toJson();
    data['outstandingAmount'] = this.outstandingAmount.toJson();
    data['country'] = this.country;
    data['aggregatorLogo'] = this.aggregatorLogo;
    data['source'] = this.source;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
