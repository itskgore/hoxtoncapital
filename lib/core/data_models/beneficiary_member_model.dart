import 'package:wedge/core/entities/beneficiary_member_entity.dart';

class BeneficiaryMembersModel extends BeneficiaryMembersEntity {
  final String name;
  final String email;
  final String contactNumber;
  final num inactivityThresholdDays;
  final bool isEmpty;
  final String id;
  final String createdAt;
  final String updatedAt;
  final String countryCode;

  BeneficiaryMembersModel(
      {required this.name,
      required this.email,
      required this.isEmpty,
      required this.contactNumber,
      required this.inactivityThresholdDays,
      required this.countryCode,
      required this.id,
      required this.createdAt,
      required this.updatedAt})
      : super(
            updatedAt: updatedAt,
            name: name,
            id: id,
            email: email,
            isEmpty: isEmpty,
            countryCode: countryCode,
            createdAt: createdAt,
            contactNumber: contactNumber,
            inactivityThresholdDays: inactivityThresholdDays);

  factory BeneficiaryMembersModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryMembersModel(
      contactNumber: json['contactNumber'] ?? "",
      isEmpty: json['isEmpty'] ?? false,
      countryCode: json['countryCode'] ?? "",
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      inactivityThresholdDays: json['inactivityThresholdDays'] ?? 0,
      id: json['id'] ?? "",
      createdAt: json['createdAt'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['countryCode'] = this.countryCode;
    data['email'] = this.email;
    data['isEmpty'] = this.isEmpty;
    data['contactNumber'] = this.contactNumber;
    data['inactivityThresholdDays'] = this.inactivityThresholdDays;
    data['id'] = this.id;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
