class UserPreferencesEntity {
  final String sId;
  final String pseudonym;
  final String resourceId;
  final String resourceType;
  final String createdAt;
  final String id;
  final bool isActive;
  final PreferenceEntity preference;
  final String updatedAt;

  UserPreferencesEntity(
      {required this.sId,
      required this.pseudonym,
      required this.resourceId,
      required this.resourceType,
      required this.createdAt,
      required this.id,
      required this.isActive,
      required this.preference,
      required this.updatedAt});
}

class PreferenceEntity {
  String? currency;
  String? preferredCurrency;

  PreferenceEntity({this.currency, this.preferredCurrency});
}
