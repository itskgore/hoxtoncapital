import 'dart:convert';

class InviteFriendsModel {
  final String? referralUrl;

  InviteFriendsModel({
    this.referralUrl,
  });

  factory InviteFriendsModel.fromRawJson(String str) =>
      InviteFriendsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InviteFriendsModel.fromJson(Map<String, dynamic> json) =>
      InviteFriendsModel(
        referralUrl: json["referralURL"],
      );

  Map<String, dynamic> toJson() => {
        "referralURL": referralUrl,
      };
}
