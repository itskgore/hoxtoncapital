class ProviderTokenEntity {
  ProviderTokenEntity({
    required this.yodlee,
    required this.saltedgeEntity,
  });

  final YodleeEntity? yodlee;
  final SaltedgeTokenEntity? saltedgeEntity;
}

class YodleeEntity {
  YodleeEntity(
      {required this.token,
      required this.fastlinkURL,
      required this.fastlinkConfiguration});
  late final YodleeTokenEntity token;
  late final String fastlinkURL;
  late final String fastlinkConfiguration;
}

class YodleeTokenEntity {
  YodleeTokenEntity({required this.accessToken, required this.expiresIn});
  late final String accessToken;
  late final int expiresIn;
}

class SaltedgeTokenEntity {
  final String expiresAt;
  final String redirectUrl;

  SaltedgeTokenEntity({required this.expiresAt, required this.redirectUrl});
}
