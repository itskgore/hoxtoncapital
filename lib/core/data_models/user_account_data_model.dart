import 'package:wedge/core/entities/user_account_data_entity.dart';

class UserAccountDataModel extends UserAccountDataEntity {
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String mobileNumber;
  final String workNumber;
  final String country;
  final String profilePic;
  final String lastLogin;
  final String createdAt;
  final String updatedAt;

  UserAccountDataModel(
      {required this.email,
      required this.firstName,
      required this.middleName,
      required this.lastName,
      required this.mobileNumber,
      required this.workNumber,
      required this.country,
      required this.profilePic,
      required this.lastLogin,
      required this.createdAt,
      required this.updatedAt})
      : super(
          country: country,
          createdAt: createdAt,
          email: email,
          firstName: firstName,
          lastLogin: lastLogin,
          lastName: lastName,
          middleName: middleName,
          mobileNumber: mobileNumber,
          profilePic: profilePic,
          updatedAt: updatedAt,
          workNumber: workNumber,
        );

  factory UserAccountDataModel.fromJson(Map<String, dynamic> json) {
    return UserAccountDataModel(
      country: json['country'] ?? "",
      createdAt: json['createdAt'] ?? "",
      email: json['email'] ?? "",
      firstName: json['firstName'] ?? "",
      lastLogin: json['lastLogin'] ?? "",
      lastName: json['lastName'] ?? "",
      middleName: json['middleName'] ?? "",
      mobileNumber: json['mobileNumber'] ?? "",
      profilePic: json['profilePic'] ?? "",
      updatedAt: json['updatedAt'] ?? "",
      workNumber: json['workNumber'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['mobileNumber'] = mobileNumber;
    data['workNumber'] = workNumber;
    data['country'] = country;
    data['profilePic'] = profilePic;
    data['lastLogin'] = lastLogin;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
