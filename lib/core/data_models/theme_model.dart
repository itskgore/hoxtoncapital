import 'dart:convert';
import 'dart:ui';

class AppTheme {
  String? clientName;
  String? termsCondition;
  String? privacyPolicy;
  bool? singleLoginFlow;
  bool? hasMyServices;
  AppColors? colors;
  AppFonts? fonts;
  AppImage? appImage;
  ApiUrls? apiUrls;
  FeatureFlag? featureFlag;
  List<NewFeatureModel>? newFeatures;

  // final String test;

  AppTheme(
      {this.colors,
      this.fonts,
      this.appImage,
      this.apiUrls,
      this.featureFlag,
      this.newFeatures,
      this.termsCondition,
      this.privacyPolicy,
      this.clientName,
      this.singleLoginFlow});

  fromJson(Map<String, dynamic> json) {
    clientName = json['clientName'] ?? "Wedge";
    privacyPolicy = json['privacyPolicy'] ?? "";
    termsCondition = json['termsCondition'] ?? "";
    hasMyServices = json['hasMyServices'] ?? false;
    singleLoginFlow = json['singleLoginFlow'] ?? true;
    colors = json['colors'] != null ? AppColors.fromJson(json['colors']) : null;
    fonts = json['fonts'] != null ? AppFonts.fromJson(json['fonts']) : null;
    appImage =
        json['appImages'] != null ? AppImage.fromJson(json['appImages']) : null;

    apiUrls =
        json['apiUrls'] != null ? ApiUrls.fromJson(json['apiUrls']) : null;

    featureFlag = json['featureFlag'] != null
        ? FeatureFlag.fromJson(json['featureFlag'])
        : null;
    if (json['newFeatures'] != null) {
      newFeatures = <NewFeatureModel>[];
      json['newFeatures'].forEach((e) {
        newFeatures!.add(NewFeatureModel.fromJson(e));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (colors != null) {
      data['colors'] = colors!.toJson();
    }
    if (fonts != null) {
      data['fonts'] = fonts!.toJson();
    }
    if (apiUrls != null) {
      data['apiUrls'] = apiUrls!.toJson();
    }
    data['clientName'] = clientName;
    data['termsCondition'] = termsCondition;
    data['privacyPolicy'] = privacyPolicy;
    data['singleLoginFlow'] = singleLoginFlow;
    data['hasMyServices'] = hasMyServices;
    return data;
  }
}

class AppColors {
  Color? primary;
  LoginColorTheme? loginColorTheme;
  Color? bg;
  Color? textLight;
  Color? textDark;
  Color? outline;
  List<Color>? gradient;
  Color? buttonText;
  Color? disableDark;
  Color? disableLight;
  Color? buttonLight;
  Color? disableText;
  List<List>? creditCards;
  ChartsTheme? charts;

  AppColors(
      {this.primary,
      this.loginColorTheme,
      this.bg,
      this.textLight,
      this.textDark,
      this.gradient,
      this.buttonText,
      this.buttonLight,
      this.outline,
      this.disableDark,
      this.disableLight,
      this.disableText,
      this.creditCards,
      this.charts});

  AppColors.fromJson(Map<String, dynamic> json) {
    primary = HexColor(json['primary'] ?? "#103833");
    if (json['gradient'] != null) {
      gradient = <Color>[];
      json['gradient'].forEach((v) {
        gradient!.add(HexColor(v));
      });
    }
    loginColorTheme = json['loginColorTheme'] != null
        ? LoginColorTheme.fromJson(json['loginColorTheme'])
        : null;
    bg = HexColor(json['bg'] ?? "##517FA2");
    buttonLight = HexColor(json['buttonLight'] ?? "#F7F8F0");
    buttonText = HexColor(json['buttonText'] ?? "#ffffff");
    textLight = HexColor(json['textLight'] ?? "#ffffff");
    textDark = HexColor(json['textDark'] ?? "#000000");
    outline = HexColor(
      json['outline'] ?? "#428DFF",
    );
    disableDark = HexColor(json['disableDark'] ?? "#CFCFCF");
    disableLight = HexColor(json['disableLight'] ?? "#EAEBE1");
    disableText = HexColor(json['disableText'] ?? "#CFCFCF");
    if (json['creditCards'] != null) {
      creditCards = <List>[];
      json['creditCards'].forEach((v) {
        creditCards!.add(List.from(v));
      });
    }
    charts =
        json['charts'] != null ? ChartsTheme.fromJson(json['charts']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['primary'] = primary;
    data['bg'] = bg;
    data['textLight'] = textLight;
    data['loginColorTheme'] = loginColorTheme;
    data['textDark'] = textDark;
    data['buttonText'] = buttonText;
    data['outline'] = outline;
    data['disableDark'] = disableDark;
    data['disableLight'] = disableLight;
    data['disableText'] = disableText;
    if (creditCards != null) {
      data['creditCards'] = creditCards!.map((v) => v.toList());
    }
    if (charts != null) {
      data['charts'] = charts!.toJson();
    }
    return data;
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class CreditCardsTheme {
  CreditCardsTheme();

  CreditCardsTheme.fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}

class ChartsTheme {
  LineChartsTheme? lineCharts;
  BarChartsTheme? barCharts;
  CalculatorChartsTheme? calculatorCharts;
  AssetsTheme? assets;
  LiabiltiesTheme? liabilties;

  ChartsTheme(
      {this.lineCharts, this.calculatorCharts, this.assets, this.liabilties});

  ChartsTheme.fromJson(Map<String, dynamic> json) {
    lineCharts = json['lineCharts'] != null
        ? LineChartsTheme.fromJson(json['lineCharts'])
        : null;
    barCharts = json['barCharts'] != null
        ? BarChartsTheme.fromJson(json['barCharts'])
        : null;
    calculatorCharts = json['calculatorCharts'] != null
        ? CalculatorChartsTheme.fromJson(json['calculatorCharts'])
        : null;
    assets =
        json['assets'] != null ? AssetsTheme.fromJson(json['assets']) : null;
    liabilties = json['liabilties'] != null
        ? LiabiltiesTheme.fromJson(json['liabilties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (lineCharts != null) {
      data['lineCharts'] = lineCharts!.toJson();
    }
    if (calculatorCharts != null) {
      data['calculatorCharts'] = calculatorCharts!.toJson();
    }
    if (assets != null) {
      data['assets'] = assets!.toJson();
    }
    if (liabilties != null) {
      data['liabilties'] = liabilties!.toJson();
    }
    return data;
  }
}

class LineChartsTheme {
  Color? line;
  Color? mainChartLineColor;
  Color? defualtChartLineColor;

  LineChartsTheme(
      {this.line, this.defualtChartLineColor, this.mainChartLineColor});

  LineChartsTheme.fromJson(Map<String, dynamic> json) {
    line = HexColor(json['line'] ?? "#428DFF");
    mainChartLineColor = HexColor(json['mainChartLineColor'] ?? "#428DFF");
    defualtChartLineColor =
        HexColor(json['defualtChartLineColor'] ?? "#428DFF");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['line'] = line;
    return data;
  }
}

class BarChartsTheme {
  Color? positive;
  Color? negative;

  BarChartsTheme({
    this.positive,
    this.negative,
  });

  BarChartsTheme.fromJson(Map<String, dynamic> json) {
    negative = HexColor(json['negative'] ?? "#428DFF");
    positive = HexColor(json['positive'] ?? "#428DFF");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['positive'] = positive;
    data['negative'] = negative;
    return data;
  }
}

class CalculatorChartsTheme {
  Color? recommended;
  Color? currentPath;

  CalculatorChartsTheme({this.recommended, this.currentPath});

  CalculatorChartsTheme.fromJson(Map<String, dynamic> json) {
    recommended = HexColor(json['recommended'] ?? "#428DFF");
    currentPath = HexColor(json['currentPath'] ?? "#616161");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['recommended'] = recommended;
    data['currentPath'] = currentPath;
    return data;
  }
}

class AssetsTheme {
  Color? mainAsset;
  Color? cashAccount;
  Color? properties;
  Color? vehicles;
  Color? investment;
  Color? pensions;
  Color? crypto;
  Color? stocks;
  Color? customAssets;
  Color? progressLineColor;

  AssetsTheme(
      {this.mainAsset,
      this.cashAccount,
      this.properties,
      this.vehicles,
      this.investment,
      this.progressLineColor,
      this.pensions,
      this.crypto,
      this.stocks,
      this.customAssets});

  AssetsTheme.fromJson(Map<String, dynamic> json) {
    mainAsset = HexColor(json['mainAsset'] ?? "#51AF86");
    cashAccount = HexColor(json['cashAccount'] ?? "#FFE07D");
    properties = HexColor(json['properties'] ?? "#F99664");
    vehicles = HexColor(json['vehicles'] ?? "#51AF86");
    investment = HexColor(json['investment'] ?? "#FF8686");
    pensions = HexColor(json['pensions'] ?? "#428DFF");
    crypto = HexColor(json['crypto'] ?? "#4F4F4F");
    progressLineColor = HexColor(json['progressLineColor'] ?? "#4F4F4F");
    stocks = HexColor(json['stocks'] ?? "#C09CCA");
    customAssets = HexColor(json['customAssets'] ?? "#B6B211");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainAsset'] = mainAsset;
    data['cashAccount'] = cashAccount;
    data['properties'] = properties;
    data['vehicles'] = vehicles;
    data['investment'] = investment;
    data['pensions'] = pensions;
    data['crypto'] = crypto;
    data['stocks'] = stocks;
    data['customAssetsTheme'] = customAssets;
    return data;
  }
}

class LiabiltiesTheme {
  Color? mainLiability;
  Color? mortgages;
  Color? creditCards;
  Color? vehicleLoans;
  Color? personLoans;
  Color? customLiabilities;
  Color? progressLineColor;

  LiabiltiesTheme(
      {this.mainLiability,
      this.mortgages,
      this.creditCards,
      this.progressLineColor,
      this.vehicleLoans,
      this.personLoans,
      this.customLiabilities});

  LiabiltiesTheme.fromJson(Map<String, dynamic> json) {
    mainLiability = HexColor(json['mainLiability'] ?? "#F47373");
    mortgages = HexColor(json['mortgages'] ?? "#FFE07D");
    creditCards = HexColor(json['creditCards'] ?? "#F99664");
    vehicleLoans = HexColor(json['vehicleLoans'] ?? "#51AF86");
    personLoans = HexColor(json['personLoans'] ?? "#FF8686");
    progressLineColor = HexColor(json['progressLineColor'] ?? "#FF8686");
    customLiabilities = HexColor(json['customLiabilities'] ?? "#428DFF");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mainLiability'] = mainLiability;
    data['mortgages'] = mortgages;
    data['creditCards'] = creditCards;
    data['vehicleLoans'] = vehicleLoans;
    data['personLoans'] = personLoans;
    data['customLiabilities'] = customLiabilities;
    return data;
  }
}

class AppFonts {
  String? genericFont;
  Headline? headline;
  AppSubtitle? subtitle;

  AppFonts({this.headline, this.subtitle, this.genericFont});

  AppFonts.fromJson(Map<String, dynamic> json) {
    genericFont = json['genericFont'];
    headline =
        json['headline'] != null ? Headline.fromJson(json['headline']) : null;
    subtitle = json['subtitle'] != null
        ? AppSubtitle.fromJson(json['subtitle'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (headline != null) {
      data['headline'] = headline!.toJson();
    }
    if (subtitle != null) {
      data['subtitle'] = subtitle!.toJson();
    }
    data['genericFont'] = genericFont;
    return data;
  }
}

class Headline {
  String? font;
  Sizes? sizes;
  bool? isBold;

  Headline({this.font, this.sizes});

  Headline.fromJson(Map<String, dynamic> json) {
    font = json['font'] ?? "Rubik";
    isBold = json['isBold'] ?? false;
    sizes = json['sizes'] != null ? Sizes.fromJson(json['sizes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['font'] = font;
    data['isBold'] = isBold;
    if (sizes != null) {
      data['sizes'] = sizes!.toJson();
    }
    return data;
  }
}

class AppSubtitle {
  String? font;
  Sizes? sizes;

  AppSubtitle({this.font, this.sizes});

  AppSubtitle.fromJson(Map<String, dynamic> json) {
    font = json['font'] ?? "Roboto";
    sizes = json['sizes'] != null ? Sizes.fromJson(json['sizes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['font'] = font;
    if (sizes != null) {
      data['sizes'] = sizes!.toJson();
    }
    return data;
  }
}

class Sizes {
  double? h1;
  double? h2;
  double? h3;
  double? h4;
  double? h5;
  double? h6;
  double? h7;
  double? h8;
  double? h9;
  double? h10;
  double? h11;
  double? h12;

  Sizes(
      {this.h1,
      this.h2,
      this.h3,
      this.h4,
      this.h5,
      this.h6,
      this.h7,
      this.h8,
      this.h9,
      this.h10,
      this.h11,
      this.h12});

  Sizes.fromJson(Map<String, dynamic> json) {
    h1 = json['h1'] ?? 32.0;
    h2 = json['h2'] ?? 30.0;
    h3 = json['h3'] ?? 28.0;
    h4 = json['h4'] ?? 26.0;
    h5 = json['h5'] ?? 24.0;
    h6 = json['h6'] ?? 22.0;
    h7 = json['h7'] ?? 20.0;
    h8 = json['h8'] ?? 18.0;
    h9 = json['h9'] ?? 16.0;
    h10 = json['h10'] ?? 14.0;
    h11 = json['h11'] ?? 12.0;
    h12 = json['h12'] ?? 10.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['h1'] = h1;
    data['h2'] = h2;
    data['h3'] = h3;
    data['h4'] = h4;
    data['h5'] = h5;
    data['h6'] = h6;
    data['h7'] = h7;
    data['h8'] = h8;
    data['h9'] = h9;
    data['h10'] = h10;
    data['h11'] = h11;
    data['h12'] = h12;
    return data;
  }
}

class AppImage {
  String? appLogoLight;
  String? appLogoDark;

  AppImage({this.appLogoLight, this.appLogoDark});

  AppImage.fromJson(Map<String, dynamic> json) {
    appLogoLight = json['appLogoLight'] ?? "assets/images/logo.png";
    appLogoDark = json['appLogoDark'] ?? "assets/images/logo_dark.png";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appLogoLight'] = appLogoLight;
    data['appLogoDark'] = appLogoDark;
    return data;
  }
}

class CompanyApiUrls {
  ApiUrls? apiUrls;

  CompanyApiUrls({this.apiUrls});

  CompanyApiUrls.fromJson(Map<String, dynamic> json) {
    apiUrls =
        json['apiUrls'] != null ? ApiUrls.fromJson(json['apiUrls']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (apiUrls != null) {
      data['apiUrls'] = apiUrls!.toJson();
    }
    return data;
  }
}

class ApiUrls {
  CompanyBaseUrl? baseUrl;
  CompanyBaseUrl? baseUrl2;
  CompanyBaseUrl? webUrls;
  AuthUrls? auth;
  EndPoints? endPoints;

  ApiUrls({this.baseUrl, this.auth, this.endPoints});

  ApiUrls.fromJson(Map<String, dynamic> json) {
    baseUrl = json['baseUrl'] != null
        ? CompanyBaseUrl.fromJson(json['baseUrl'])
        : null;
    baseUrl2 = json['baseUrl2'] != null
        ? CompanyBaseUrl.fromJson(json['baseUrl2'])
        : null;
    webUrls = json['webUrls'] != null
        ? CompanyBaseUrl.fromJson(json['webUrls'])
        : null;
    auth = json['auth'] != null ? AuthUrls.fromJson(json['auth']) : null;
    endPoints = json['endPoints'] != null
        ? EndPoints.fromJson(json['endPoints'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (baseUrl != null) {
      data['baseUrl'] = baseUrl!.toJson();
    }
    if (baseUrl2 != null) {
      data['baseUrl2'] = baseUrl2!.toJson();
    }
    if (webUrls != null) {
      data['webUrls'] = webUrls!.toJson();
    }
    if (auth != null) {
      data['auth'] = auth!.toJson();
    }
    if (endPoints != null) {
      data['endPoints'] = endPoints!.toJson();
    }
    return data;
  }
}

class CompanyBaseUrl {
  String? prod;
  String? qa;
  String? stage;
  String? mock;

  CompanyBaseUrl({this.prod, this.qa, this.stage, this.mock});

  CompanyBaseUrl.fromJson(Map<String, dynamic> json) {
    prod = json['prod'];
    qa = json['qa'];
    stage = json['stage'];
    mock = json['mock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['prod'] = prod;
    data['qa'] = qa;
    data['stage'] = stage;
    data['mock'] = mock;
    return data;
  }
}

class AuthUrls {
  CompanyBaseUrl? login;
  CompanyBaseUrl? forgotPassword;
  CompanyBaseUrl? validateOtp;
  CompanyBaseUrl? baseUrl;
  CompanyBaseUrl? baseUrl2;
  CompanyBaseUrl? reSendOtp;

  AuthUrls({this.login, this.forgotPassword});

  AuthUrls.fromJson(Map<String, dynamic> json) {
    login =
        json['login'] != null ? CompanyBaseUrl.fromJson(json['login']) : null;
    forgotPassword = json['forgotPassword'] != null
        ? CompanyBaseUrl.fromJson(json['forgotPassword'])
        : null;
    validateOtp = json['validateOtp'] != null
        ? CompanyBaseUrl.fromJson(json['validateOtp'])
        : null;
    reSendOtp = json['reSendOtp'] != null
        ? CompanyBaseUrl.fromJson(json['reSendOtp'])
        : null;
    baseUrl = json['baseUrl'] != null
        ? CompanyBaseUrl.fromJson(json['baseUrl'])
        : null;
    baseUrl2 = json['baseUrl2'] != null
        ? CompanyBaseUrl.fromJson(json['baseUrl2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (login != null) {
      data['login'] = login!.toJson();
    }
    if (forgotPassword != null) {
      data['forgotPassword'] = forgotPassword!.toJson();
    }
    if (baseUrl != null) {
      data['baseUrl'] = baseUrl!.toJson();
    }
    if (baseUrl2 != null) {
      data['baseUrl2'] = baseUrl2!.toJson();
    }
    if (validateOtp != null) {
      data['validateOtp'] = validateOtp!.toJson();
    }
    if (reSendOtp != null) {
      data['reSendOtp'] = reSendOtp!.toJson();
    }
    return data;
  }
}

// ========================
class EndPoints {
  String? fiancialInformationEndpoint;
  String? identitynEndpoint;
  String? notificationEndPoint;
  String? userPreferenceEndpoint;
  String? insightsEndpoint;
  String? documentValtEndPoint;

  EndPoints(
      {this.fiancialInformationEndpoint,
      this.identitynEndpoint,
      this.notificationEndPoint,
      this.userPreferenceEndpoint,
      this.insightsEndpoint,
      this.documentValtEndPoint});

  EndPoints.fromJson(Map<String, dynamic> json) {
    fiancialInformationEndpoint = json['fiancialInformationEndpoint'];
    identitynEndpoint = json['identitynEndpoint'];
    notificationEndPoint = json['notificationEndPoint'];
    userPreferenceEndpoint = json['userPreferenceEndpoint'];
    insightsEndpoint = json['insightsEndpoint'];
    documentValtEndPoint = json['documentValtEndPoint'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fiancialInformationEndpoint'] = fiancialInformationEndpoint;
    data['notificationEndPoint'] = notificationEndPoint;
    data['userPreferenceEndpoint'] = userPreferenceEndpoint;
    data['insightsEndpoint'] = insightsEndpoint;
    data['documentValtEndPoint'] = documentValtEndPoint;
    return data;
  }
}

class LoginColorTheme {
  Color? bgColor;
  Color? buttonColor;
  Color? textTitleColor;
  Color? textSubtitleColor;
  Color? textFieldFillColor;
  Color? textFieldPlaceholderColor;
  Color? textFieldTextStyle;
  bool? darkLogo;

  LoginColorTheme(
      {this.bgColor,
      this.buttonColor,
      this.textTitleColor,
      this.textSubtitleColor,
      this.textFieldTextStyle,
      this.textFieldFillColor,
      this.darkLogo,
      this.textFieldPlaceholderColor});

  LoginColorTheme.fromJson(Map<String, dynamic> json) {
    bgColor = HexColor(json['bgColor'] ?? "#11403A");
    textFieldTextStyle = HexColor(json['textFieldTextStyle'] ?? "#000000");
    buttonColor = HexColor(json['buttonColor'] ?? "#000000");
    textTitleColor = HexColor(json['textTitleColor'] ?? "#ffffff");
    textSubtitleColor = HexColor(json['textSubtitleColor'] ?? "#F6F6F6");
    textFieldFillColor = HexColor(json['textFieldFillColor'] ?? "#0E3833");
    textFieldPlaceholderColor =
        HexColor(json['textFieldPlaceholderColor'] ?? "#FFFFFF");
    darkLogo = json['darkLogo'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bgColor'] = bgColor;
    data['buttonColor'] = buttonColor;
    data['textFieldTextStyle'] = textFieldTextStyle;
    data['textTitleColor'] = textTitleColor;
    data['darkLogo'] = darkLogo;
    data['textSubtitleColor'] = textSubtitleColor;
    data['textFieldFillColor'] = textFieldFillColor;
    data['textFieldPlaceholderColor'] = textFieldPlaceholderColor;
    return data;
  }
}

class FeatureFlag {
  final Prod qa;
  final Prod stage;
  final Prod prod;

  FeatureFlag({
    required this.qa,
    required this.stage,
    required this.prod,
  });

  factory FeatureFlag.fromRawJson(String str) =>
      FeatureFlag.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FeatureFlag.fromJson(Map<String, dynamic> json) => FeatureFlag(
        qa: Prod.fromJson(json["qa"]),
        stage: Prod.fromJson(json["stage"]),
        prod: Prod.fromJson(json["prod"]),
      );

  Map<String, dynamic> toJson() => {
        "qa": qa.toJson(),
        "stage": stage.toJson(),
        "prod": prod.toJson(),
      };
}

class NewFeatureModel {
  final String name;
  final String launchDate;
  final String durationDays;

  NewFeatureModel({
    required this.name,
    required this.launchDate,
    required this.durationDays,
  });

  factory NewFeatureModel.fromRawJson(String str) =>
      NewFeatureModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NewFeatureModel.fromJson(Map<String, dynamic> json) =>
      NewFeatureModel(
        name: json["name"],
        launchDate: json["launchDate"],
        durationDays: json["DurationDays"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "launchDate": launchDate,
        "DurationDays": durationDays,
      };
}

class Prod {
  final bool enableMixpanel;
  final bool enableUserReferral;

  Prod({
    required this.enableMixpanel,
    required this.enableUserReferral,
  });

  factory Prod.fromRawJson(String str) => Prod.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Prod.fromJson(Map<String, dynamic> json) => Prod(
        enableMixpanel: json["enableMixpanel"],
        enableUserReferral: json["enableUserReferral"],
      );

  Map<String, dynamic> toJson() => {
        "enableMixpanel": enableMixpanel,
        "enableUserReferral": enableUserReferral,
      };
}
