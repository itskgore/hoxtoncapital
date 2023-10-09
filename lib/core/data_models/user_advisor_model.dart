import 'package:wedge/core/entities/user_advisor_entity.dart';

class UserAdvisorModel extends UserAdvisorEntity {
  final String imageUrl;
  final String title;
  final String name;
  final String email;
  final String mobilePhone;
  final String linkedinUrl;

  UserAdvisorModel(
      {required this.imageUrl,
      required this.title,
      required this.name,
      required this.email,
      required this.mobilePhone,
      required this.linkedinUrl})
      : super(
            email: email,
            imageUrl: imageUrl,
            linkedinUrl: linkedinUrl,
            mobilePhone: mobilePhone,
            name: name,
            title: title);

  factory UserAdvisorModel.fromJson(Map<String, dynamic> json) {
    return UserAdvisorModel(
        imageUrl: json['imageUrl'] ?? "",
        title: json['title'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        mobilePhone: json['mobilePhone'] ?? "",
        linkedinUrl: json['linkedinUrl'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = imageUrl;
    data['title'] = title;
    data['name'] = name;
    data['email'] = email;
    data['mobilePhone'] = mobilePhone;
    data['linkedinUrl'] = linkedinUrl;
    return data;
  }
}
