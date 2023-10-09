import 'dart:convert';

class CardAndCashTransactionModel {
  Cursor? cursor;
  List<Record>? records;
  Summary? summary;

  CardAndCashTransactionModel({
    this.cursor,
    this.records,
    this.summary,
  });

  factory CardAndCashTransactionModel.fromRawJson(String str) =>
      CardAndCashTransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CardAndCashTransactionModel.fromJson(Map<String, dynamic> json) =>
      CardAndCashTransactionModel(
        cursor: json["cursor"] == null ? null : Cursor.fromJson(json["cursor"]),
        records: json["records"] == null
            ? []
            : List<Record>.from(
                json["records"]!.map((x) => Record.fromJson(x))),
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
      );

  Map<String, dynamic> toJson() => {
        "cursor": cursor?.toJson(),
        "records": records == null
            ? []
            : List<dynamic>.from(records!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
      };
}

class Cursor {
  int? currentPage;
  int? perPage;
  int? totalRecords;

  Cursor({
    this.currentPage,
    this.perPage,
    this.totalRecords,
  });

  factory Cursor.fromRawJson(String str) => Cursor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Cursor.fromJson(Map<String, dynamic> json) => Cursor(
        currentPage: json["currentPage"],
        perPage: json["perPage"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "currentPage": currentPage,
        "perPage": perPage,
        "totalRecords": totalRecords,
      };
}

class Record {
  String? id;
  String? aggregatorAccountId;
  Amount? amount;
  String? baseType;
  String? category;
  DateTime? date;
  String? recordId;
  Merchant? merchant;

  Record({
    this.id,
    this.aggregatorAccountId,
    this.amount,
    this.baseType,
    this.category,
    this.date,
    this.recordId,
    this.merchant,
  });

  factory Record.fromRawJson(String str) => Record.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Record.fromJson(Map<String, dynamic> json) => Record(
        id: json["_id"],
        aggregatorAccountId: json["aggregatorAccountId"],
        amount: json["amount"] == null ? null : Amount.fromJson(json["amount"]),
        baseType: json["baseType"],
        category: json["category"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        recordId: json["id"],
        merchant: json["merchant"] == null
            ? null
            : Merchant.fromJson(json["merchant"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "aggregatorAccountId": aggregatorAccountId,
        "amount": amount?.toJson(),
        "baseType": baseType,
        "category": category,
        "date": date?.toIso8601String(),
        "id": recordId,
        "merchant": merchant?.toJson(),
      };
}

class Amount {
  double? amount;
  String? currency;

  Amount({
    this.amount,
    this.currency,
  });

  factory Amount.fromRawJson(String str) => Amount.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Amount.fromJson(Map<String, dynamic> json) => Amount(
        amount: json["amount"]?.toDouble(),
        currency: json["currency"]!,
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
      };
}

class Merchant {
  String? id;
  String? name;
  String? transliteratedName;
  String? website;
  Address? address;

  Merchant({
    this.id,
    this.name,
    this.transliteratedName,
    this.website,
    this.address,
  });

  factory Merchant.fromRawJson(String str) =>
      Merchant.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Merchant.fromJson(Map<String, dynamic> json) => Merchant(
        id: json["id"],
        name: json["name"],
        transliteratedName: json["transliterated_name"],
        website: json["website"],
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "transliterated_name": transliteratedName,
        "website": website,
        "address": address?.toJson(),
      };
}

class Address {
  Address();

  factory Address.fromRawJson(String str) => Address.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Address.fromJson(Map<String, dynamic> json) => Address();

  Map<String, dynamic> toJson() => {};
}

class Summary {
  double? totalDebitAmount;
  double? totalCreditAmount;

  Summary({
    this.totalDebitAmount,
    this.totalCreditAmount,
  });

  factory Summary.fromRawJson(String str) => Summary.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        totalDebitAmount: json["totalDebitAmount"]?.toDouble(),
        totalCreditAmount: json["totalCreditAmount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "totalDebitAmount": totalDebitAmount,
        "totalCreditAmount": totalCreditAmount,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
