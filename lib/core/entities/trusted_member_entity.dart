class TrustedMembersEntity {
  final String name;
  final String email;
  final String contactNumber;
  final String id;
  final String updatedAt;
  final String createdAt;
  final String countryCode;
  final bool isEmpty;

  TrustedMembersEntity(
      {required this.name,
      required this.email,
      required this.contactNumber,
      required this.countryCode,
      required this.isEmpty,
      required this.id,
      required this.updatedAt,
      required this.createdAt});
}
