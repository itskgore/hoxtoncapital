import 'package:wedge/features/account/third_party_access/data/model/third_party_access_entity.dart';

class ThirdPartyAccessModel extends ThirdPartyAccessEntity {
  String? name;
  String? email;
  String? role;
  String? accessLevel;
  List<dynamic>? permissions;
  String? lastLoginAt;

  ThirdPartyAccessModel(
      {this.name,
      this.email,
      this.role,
      this.accessLevel,
      this.permissions,
      this.lastLoginAt});

  ThirdPartyAccessModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    role = json['role'];
    accessLevel = json['accessLevel'];
    if (json['permissions'] != null) {
      permissions = <dynamic>[];
      json['permissions'].forEach((v) {
        permissions!.add(v);
      });
    }
    lastLoginAt = json['lastLoginAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['accessLevel'] = accessLevel;
    data['permissions'] = permissions;
    data['lastLoginAt'] = lastLoginAt;
    return data;
  }
}
