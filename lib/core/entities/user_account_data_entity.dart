class UserAccountDataEntity {
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

  UserAccountDataEntity(
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
      required this.updatedAt});
}
