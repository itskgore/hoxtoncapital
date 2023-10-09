class ThirdPartyAccessEntity {
  String? name;
  String? email;
  String? role;
  String? accessLevel;
  List<dynamic>? permissions;
  String? lastLoginAt;

  ThirdPartyAccessEntity(
      {this.name,
      this.email,
      this.role,
      this.accessLevel,
      this.permissions,
      this.lastLoginAt});
}
