class TenantModel {
  String? sId;
  String? code;
  String? name;
  Contact? contact;
  String? website;
  List<SocialAccounts>? socialAccounts;
  Preferences? preferences;
  bool? isActive;
  String? createdBy;
  String? updatedBy;
  String? id;
  String? createdAt;
  String? updatedAt;

  TenantModel(
      {this.sId,
      this.code,
      this.name,
      this.contact,
      this.website,
      this.socialAccounts,
      this.preferences,
      this.isActive,
      this.createdBy,
      this.updatedBy,
      this.id,
      this.createdAt,
      this.updatedAt});

  TenantModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    code = json['code'];
    name = json['name'];
    contact =
        json['contact'] != null ? Contact.fromJson(json['contact']) : null;
    website = json['website'];
    if (json['socialAccounts'] != null) {
      socialAccounts = <SocialAccounts>[];
      json['socialAccounts'].forEach((v) {
        socialAccounts!.add(SocialAccounts.fromJson(v));
      });
    }
    preferences = json['preferences'] != null
        ? Preferences.fromJson(json['preferences'])
        : null;
    isActive = json['isActive'];
    createdBy = json['createdBy'];
    updatedBy = json['updatedBy'];
    id = json['id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['code'] = code;
    data['name'] = name;
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    data['website'] = website;
    if (socialAccounts != null) {
      data['socialAccounts'] = socialAccounts!.map((v) => v.toJson()).toList();
    }
    if (preferences != null) {
      data['preferences'] = preferences!.toJson();
    }
    data['isActive'] = isActive;
    data['createdBy'] = createdBy;
    data['updatedBy'] = updatedBy;
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}

class Contact {
  String? name;
  String? email;
  String? mobile;
  String? phone;

  Contact({this.name, this.email, this.mobile, this.phone});

  Contact.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['phone'] = phone;
    return data;
  }
}

class SocialAccounts {
  String? name;
  String? url;

  SocialAccounts({this.name, this.url});

  SocialAccounts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}

class Preferences {
  Password? password;
  PushNotification? pushNotification;
  ImportFi? importFi;
  Themes? themes;
  Mobile? mobile;
  Portal? portal;
  NewsFeed? newsFeed;
  String? baseURL;
  bool? hasPlugin;
  String? logo;
  String? supportEmail;

  Preferences(
      {this.password,
      this.pushNotification,
      this.importFi,
      this.themes,
      this.mobile,
      this.portal,
      this.newsFeed,
      this.baseURL,
      this.hasPlugin,
      this.logo,
      this.supportEmail});

  Preferences.fromJson(Map<String, dynamic> json) {
    password =
        json['password'] != null ? Password.fromJson(json['password']) : null;
    pushNotification = json['pushNotification'] != null
        ? PushNotification.fromJson(json['pushNotification'])
        : null;
    importFi =
        json['importFi'] != null ? ImportFi.fromJson(json['importFi']) : null;
    themes = json['themes'] != null ? Themes.fromJson(json['themes']) : null;
    mobile = json['mobile'] != null ? Mobile.fromJson(json['mobile']) : null;
    portal = json['portal'] != null ? Portal.fromJson(json['portal']) : null;
    newsFeed =
        json['newsFeed'] != null ? NewsFeed.fromJson(json['newsFeed']) : null;
    baseURL = json['baseURL'];
    hasPlugin = json['hasPlugin'];
    logo = json['logo'];
    supportEmail = json['supportEmail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (password != null) {
      data['password'] = password!.toJson();
    }
    if (pushNotification != null) {
      data['pushNotification'] = pushNotification!.toJson();
    }
    if (importFi != null) {
      data['importFi'] = importFi!.toJson();
    }
    if (themes != null) {
      data['themes'] = themes!.toJson();
    }
    if (mobile != null) {
      data['mobile'] = mobile!.toJson();
    }
    if (portal != null) {
      data['portal'] = portal!.toJson();
    }
    if (newsFeed != null) {
      data['newsFeed'] = newsFeed!.toJson();
    }
    data['baseURL'] = baseURL;
    data['hasPlugin'] = hasPlugin;
    data['logo'] = logo;
    data['supportEmail'] = supportEmail;
    return data;
  }
}

class Password {
  Instructions? instructions;
  String? regExp;

  Password({this.instructions, this.regExp});

  Password.fromJson(Map<String, dynamic> json) {
    instructions = json['instructions'] != null
        ? Instructions.fromJson(json['instructions'])
        : null;
    regExp = json['regExp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (instructions != null) {
      data['instructions'] = instructions!.toJson();
    }
    data['regExp'] = regExp;
    return data;
  }
}

class Instructions {
  String? portal;
  String? mobile;

  Instructions({this.portal, this.mobile});

  Instructions.fromJson(Map<String, dynamic> json) {
    portal = json['portal'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['portal'] = portal;
    data['mobile'] = mobile;
    return data;
  }
}

class PushNotification {
  String? provider;
  Config? config;

  PushNotification({this.provider, this.config});

  PushNotification.fromJson(Map<String, dynamic> json) {
    provider = json['provider'];
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider'] = provider;
    if (config != null) {
      data['config'] = config!.toJson();
    }
    return data;
  }
}

class Config {
  Admin? admin;
  String? apiKey;
  String? authDomain;
  String? projectId;
  String? storageBucket;
  String? messagingSenderId;
  String? appId;
  String? measurementId;

  Config(
      {this.admin,
      this.apiKey,
      this.authDomain,
      this.projectId,
      this.storageBucket,
      this.messagingSenderId,
      this.appId,
      this.measurementId});

  Config.fromJson(Map<String, dynamic> json) {
    admin = json['admin'] != null ? Admin.fromJson(json['admin']) : null;
    apiKey = json['apiKey'];
    authDomain = json['authDomain'];
    projectId = json['projectId'];
    storageBucket = json['storageBucket'];
    messagingSenderId = json['messagingSenderId'];
    appId = json['appId'];
    measurementId = json['measurementId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (admin != null) {
      data['admin'] = admin!.toJson();
    }
    data['apiKey'] = apiKey;
    data['authDomain'] = authDomain;
    data['projectId'] = projectId;
    data['storageBucket'] = storageBucket;
    data['messagingSenderId'] = messagingSenderId;
    data['appId'] = appId;
    data['measurementId'] = measurementId;
    return data;
  }
}

class Admin {
  String? type;
  String? projectId;
  String? privateKeyId;
  String? privateKey;
  String? clientEmail;
  String? clientId;
  String? authUri;
  String? tokenUri;
  String? authProviderX509CertUrl;
  String? clientX509CertUrl;

  Admin(
      {this.type,
      this.projectId,
      this.privateKeyId,
      this.privateKey,
      this.clientEmail,
      this.clientId,
      this.authUri,
      this.tokenUri,
      this.authProviderX509CertUrl,
      this.clientX509CertUrl});

  Admin.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    projectId = json['project_id'];
    privateKeyId = json['private_key_id'];
    privateKey = json['private_key'];
    clientEmail = json['client_email'];
    clientId = json['client_id'];
    authUri = json['auth_uri'];
    tokenUri = json['token_uri'];
    authProviderX509CertUrl = json['auth_provider_x509_cert_url'];
    clientX509CertUrl = json['client_x509_cert_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['project_id'] = projectId;
    data['private_key_id'] = privateKeyId;
    data['private_key'] = privateKey;
    data['client_email'] = clientEmail;
    data['client_id'] = clientId;
    data['auth_uri'] = authUri;
    data['token_uri'] = tokenUri;
    data['auth_provider_x509_cert_url'] = authProviderX509CertUrl;
    data['client_x509_cert_url'] = clientX509CertUrl;
    return data;
  }
}

class ImportFi {
  List<String>? flushHoldings;

  ImportFi({this.flushHoldings});

  ImportFi.fromJson(Map<String, dynamic> json) {
    flushHoldings = json['flushHoldings'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['flushHoldings'] = flushHoldings;
    return data;
  }
}

class Themes {
  Mobile? mobile;
  Mobile? portal;

  Themes({this.mobile, this.portal});

  Themes.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'] != null ? Mobile.fromJson(json['mobile']) : null;
    portal = json['portal'] != null ? Mobile.fromJson(json['portal']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mobile != null) {
      data['mobile'] = mobile!.toJson();
    }
    if (portal != null) {
      data['portal'] = portal!.toJson();
    }
    return data;
  }
}

class Mobile {
  int? mPinDigit;

  Mobile({this.mPinDigit});

  Mobile.fromJson(Map<String, dynamic> json) {
    mPinDigit = json['mPinDigit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mPinDigit'] = mPinDigit;
    return data;
  }
}

class Portal {
  Authentication? authentication;
  Advertisement? advertisement;
  Hotjar? hotjar;

  Portal({this.authentication, this.advertisement, this.hotjar});

  Portal.fromJson(Map<String, dynamic> json) {
    authentication = json['authentication'] != null
        ? Authentication.fromJson(json['authentication'])
        : null;
    advertisement = json['advertisement'] != null
        ? Advertisement.fromJson(json['advertisement'])
        : null;
    hotjar = json['hotjar'] != null ? Hotjar.fromJson(json['hotjar']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (authentication != null) {
      data['authentication'] = authentication!.toJson();
    }
    if (advertisement != null) {
      data['advertisement'] = advertisement!.toJson();
    }
    if (hotjar != null) {
      data['hotjar'] = hotjar!.toJson();
    }
    return data;
  }
}

class Authentication {
  bool? isSSO;
  String? redirectLoginURL;
  String? changePasswordURL;

  Authentication({this.isSSO, this.redirectLoginURL, this.changePasswordURL});

  Authentication.fromJson(Map<String, dynamic> json) {
    isSSO = json['isSSO'];
    redirectLoginURL = json['redirectLoginURL'];
    changePasswordURL = json['changePasswordURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSSO'] = isSSO;
    data['redirectLoginURL'] = redirectLoginURL;
    data['changePasswordURL'] = changePasswordURL;
    return data;
  }
}

class Advertisement {
  String? s3Url;

  Advertisement({this.s3Url});

  Advertisement.fromJson(Map<String, dynamic> json) {
    s3Url = json['S3Url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['S3Url'] = s3Url;
    return data;
  }
}

class Hotjar {
  bool? isEnabled;
  Config? config;

  Hotjar({this.isEnabled, this.config});

  Hotjar.fromJson(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'];
    config = json['config'] != null ? Config.fromJson(json['config']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isEnabled'] = isEnabled;
    if (config != null) {
      data['config'] = config!.toJson();
    }
    return data;
  }
}

class NewsFeed {
  String? aPIURL;

  NewsFeed({this.aPIURL});

  NewsFeed.fromJson(Map<String, dynamic> json) {
    aPIURL = json['APIURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['APIURL'] = aPIURL;
    return data;
  }
}
