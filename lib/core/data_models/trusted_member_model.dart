import 'package:wedge/core/entities/trusted_member_entity.dart';

class TrustedMembersModel extends TrustedMembersEntity {
  final String name;
  final String email;
  final String contactNumber;
  final String id;
  final String updatedAt;
  final String countryCode;
  final String createdAt;
  final bool isEmpty;

  TrustedMembersModel(
      {required this.name,
      required this.email,
      required this.contactNumber,
      required this.id,
      required this.isEmpty,
      required this.countryCode,
      required this.updatedAt,
      required this.createdAt})
      : super(
          contactNumber: contactNumber,
          createdAt: createdAt,
          countryCode: countryCode,
          email: email,
          id: id,
          isEmpty: isEmpty,
          name: name,
          updatedAt: updatedAt,
        );

  factory TrustedMembersModel.fromJson(Map<String, dynamic> json) {
    return TrustedMembersModel(
        name: json['name'] ?? "",
        countryCode: json['countryCode'] ?? "",
        email: json['email'] ?? "",
        isEmpty: json['isEmpty'] ?? false,
        contactNumber: json['contactNumber'] ?? "",
        id: json['id'] ?? "",
        updatedAt: json['updatedAt'] ?? "",
        createdAt: json['createdAt'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['countryCode'] = countryCode;
    data['email'] = email;
    data['contactNumber'] = contactNumber;
    data['id'] = id;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}
