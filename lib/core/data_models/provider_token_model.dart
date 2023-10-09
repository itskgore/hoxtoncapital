import 'package:wedge/core/entities/provider_token_entity.dart';

class ProviderTokenModel extends ProviderTokenEntity {
  ProviderTokenModel({
    required this.yodlee,
    required this.saltedgeModel,
  }) : super(yodlee: yodlee, saltedgeEntity: saltedgeModel);
  final SaltedgeToken? saltedgeModel;
  final YodleeModel? yodlee;

  factory ProviderTokenModel.fromJson(Map<String, dynamic> json) {
    return ProviderTokenModel(
      saltedgeModel: json['saltedge'] != null
          ? SaltedgeToken.fromJson(json['saltedge'])
          : null,
      yodlee:
          json['yodlee'] != null ? YodleeModel.fromJson(json['yodlee']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['yodlee'] = yodlee?.toJson();

    return _data;
  }
}

class YodleeModel extends YodleeEntity {
  YodleeModel(
      {required this.token,
      required this.fastlinkURL,
      required this.fastlinkConfiguration})
      : super(
            token: token,
            fastlinkURL: fastlinkURL,
            fastlinkConfiguration: fastlinkConfiguration);
  final YodleeTokenModel token;
  final String fastlinkURL;
  final String fastlinkConfiguration;

  factory YodleeModel.fromJson(Map<String, dynamic> json) {
    return YodleeModel(
      token: YodleeTokenModel.fromJson(json['token']),
      fastlinkURL: json['fastlinkURL'],
      fastlinkConfiguration: json['fastlinkConfiguration'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token.toJson();
    _data['fastlinkURL'] = fastlinkURL;
    _data['fastlinkConfiguration'] = fastlinkConfiguration;
    return _data;
  }
}

class YodleeTokenModel extends YodleeTokenEntity {
  YodleeTokenModel({
    required this.accessToken,
    required this.expiresIn,
  }) : super(accessToken: accessToken, expiresIn: expiresIn);
  late final String accessToken;
  late final int expiresIn;

  factory YodleeTokenModel.fromJson(Map<String, dynamic> json) {
    return YodleeTokenModel(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['accessToken'] = accessToken;
    _data['expiresIn'] = expiresIn;

    return _data;
  }
}

// class SaltedgeModel extends SaltedgeEntity {
//   final SaltedgeToken saltedge;

//   SaltedgeModel({required this.saltedge}) : super(saltedge: saltedge);

//   factory SaltedgeModel.fromJson(Map<String, dynamic> json) {
//     return SaltedgeModel(saltedge: SaltedgeToken.fromJson(json['saltedge']));
//   }
// }

class SaltedgeToken extends SaltedgeTokenEntity {
  final String expiresAt;
  final String redirectUrl;

  SaltedgeToken({required this.expiresAt, required this.redirectUrl})
      : super(expiresAt: expiresAt, redirectUrl: redirectUrl);

  factory SaltedgeToken.fromJson(Map<String, dynamic> json) {
    return SaltedgeToken(
      expiresAt: json['expires_at'] ?? "",
      redirectUrl: json['redirect_url'] ?? "",
    );
  }
}
