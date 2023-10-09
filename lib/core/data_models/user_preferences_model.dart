import 'package:wedge/core/entities/user_preferences_entity.dart';

class UserPreferencesModel extends UserPreferencesEntity {
  final String sId;
  final String pseudonym;
  final String resourceId;
  final String resourceType;
  final String createdAt;
  final String id;
  final bool isActive;
  final Preference preference;
  final String updatedAt;

  UserPreferencesModel(
      {required this.sId,
      required this.pseudonym,
      required this.resourceId,
      required this.resourceType,
      required this.createdAt,
      required this.id,
      required this.isActive,
      required this.preference,
      required this.updatedAt})
      : super(
            createdAt: createdAt,
            id: id,
            isActive: isActive,
            preference: preference,
            pseudonym: pseudonym,
            resourceId: resourceId,
            resourceType: createdAt,
            sId: sId,
            updatedAt: updatedAt);

  factory UserPreferencesModel.fromJson(Map<String, dynamic> json) {
    return UserPreferencesModel(
        createdAt: json['createdAt'] ?? "",
        id: json['_id'] ?? "",
        isActive: json['isActive'] ?? true,
        preference: Preference.fromJson(json['preference']),
        pseudonym: json['pseudonym'] ?? "",
        resourceId: json['resourceId'] ?? "",
        resourceType: json['resourceType'] ?? "",
        sId: json['_id'] ?? "",
        updatedAt: json['updatedAt'] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = sId;
    data['pseudonym'] = pseudonym;
    data['resourceId'] = resourceId;
    data['resourceType'] = resourceType;
    data['createdAt'] = createdAt;
    data['id'] = id;
    data['isActive'] = isActive;
    if (preference != null) {
      data['preference'] = preference.toJson();
    }
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Preference extends PreferenceEntity {
  final String currency;
  final String preferredCurrency;

  Preference({required this.currency, required this.preferredCurrency});

  factory Preference.fromJson(Map<String, dynamic> json) {
    return Preference(
      currency: json['currency'] ?? "",
      preferredCurrency: json['preferredCurrency'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currency'] = currency;
    data['preferredCurrency'] = preferredCurrency;
    return data;
  }
}
