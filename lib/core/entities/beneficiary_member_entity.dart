class BeneficiaryMembersEntity {
  final String name;
  final String email;
  final String contactNumber;
  final num inactivityThresholdDays;
  final String id;
  final String createdAt;
  final bool isEmpty;
  final String countryCode;
  final String updatedAt;

  BeneficiaryMembersEntity(
      {required this.name,
      required this.email,
      required this.countryCode,
      required this.contactNumber,
      required this.isEmpty,
      required this.inactivityThresholdDays,
      required this.id,
      required this.createdAt,
      required this.updatedAt});
}
