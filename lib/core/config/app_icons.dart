class AppIcons {
  HomePaths? homePaths;
  String? appLoader;
  String? addMoreButton;
  String? yodleeIcon;
  String? successIcon;
  String? countriesIcon;
  String? aggregatorIcon;
  String? logoutIcon;
  String? inviteFriendsIcon;
  PensionInvestPaths? pensionInvestPaths;
  FinancialCalPaths? financialCalPaths;
  WealthVaultPaths? wealthVaultPaths;
  SupportPaths? supportPaths;
  AssetsPaths? assetsPaths;
  LiabilityPaths? liabilityPaths;
  AssetLiabilitiesPaths? assetLiabilitiesPath;
  MyAccountPaths? myAccountPaths;

  AppIcons(
      {this.homePaths,
      this.successIcon,
      this.yodleeIcon,
      this.assetLiabilitiesPath,
      this.appLoader,
      this.pensionInvestPaths,
      this.logoutIcon,
      this.inviteFriendsIcon,
      this.countriesIcon,
      this.aggregatorIcon,
      this.addMoreButton,
      this.financialCalPaths,
      this.wealthVaultPaths,
      this.supportPaths,
      this.assetsPaths,
      this.liabilityPaths,
      this.myAccountPaths});

  fromJson(Map<String, dynamic> json) {
    homePaths = HomePaths.fromJson(json['homePaths']);
    appLoader = json['appLoader'];
    countriesIcon = json['countriesIcon'];
    logoutIcon = json['logoutIcon'];
    inviteFriendsIcon = json['inviteFriendsIcon'];
    aggregatorIcon = json['aggregatorIcon'];
    yodleeIcon = json['yodleeIcon'];
    successIcon = json['successIcon'];
    addMoreButton = json['addMoreButton'];
    pensionInvestPaths =
        PensionInvestPaths.fromJson(json['pensionInvestPaths']);
    assetLiabilitiesPath =
        AssetLiabilitiesPaths.fromJson(json['assetsLiabilities']);
    financialCalPaths = FinancialCalPaths.fromJson(json['financialCalPaths']);
    wealthVaultPaths = WealthVaultPaths.fromJson(json['wealthVaultPaths']);
    supportPaths = SupportPaths.fromJson(json['supportPaths']);
    assetsPaths = AssetsPaths.fromJson(json['assetsPaths']);
    liabilityPaths = LiabilityPaths.fromJson(json['liabilityPaths']);
    myAccountPaths = MyAccountPaths.fromJson(json['myAccountPaths']);
  }
}

class AssetLiabilitiesPaths {
  String? drawerIcon;

  AssetLiabilitiesPaths({required this.drawerIcon});

  AssetLiabilitiesPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
  }
}

class HomePaths {
  String? drawerIcon;

  HomePaths({this.drawerIcon});

  HomePaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
  }
}

class PensionInvestPaths {
  String? drawerIcon;
  PensionInvestPaths({this.drawerIcon});

  PensionInvestPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
  }
}

class FinancialCalPaths {
  String? drawerIcon;
  String? homeIcon;
  FinancialCalPaths({this.drawerIcon, this.homeIcon});

  FinancialCalPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
    homeIcon = json['drawerIcon'];
  }
}

class WealthVaultPaths {
  String? drawerIcon;
  String? homeIcon;
  WealthVaultPaths({this.drawerIcon, this.homeIcon});

  WealthVaultPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
    homeIcon = json['drawerIcon'];
  }
}

class SupportPaths {
  String? drawerIcon;
  String? supportBanner;
  SupportPaths({this.drawerIcon, this.supportBanner});

  SupportPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
    supportBanner = json['supportBanner'];
  }
}

class AssetsPaths {
  String? drawerIcon;
  String? mainIcons;
  String? secondaryIcon;
  String? debitIcon;
  String? creditIcon;
  MainIconPaths? cashAccount;
  MainIconPaths? properties;
  MainIconPaths? vechicles;
  MainIconPaths? investments;
  MainIconPaths? pensions;
  MainIconPaths? cryptoCurrency;
  MainIconPaths? stockBonds;
  MainIconPaths? customAssets;

  AssetsPaths(
      {this.drawerIcon,
      this.mainIcons,
      this.cashAccount,
      this.properties,
      this.debitIcon,
      this.creditIcon,
      this.secondaryIcon,
      this.vechicles,
      this.investments,
      this.pensions,
      this.cryptoCurrency,
      this.stockBonds,
      this.customAssets});

  AssetsPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
    mainIcons = json['mainIcons'];
    debitIcon = json['debitIcon'];
    secondaryIcon = json['secondaryIcon'];
    creditIcon = json['creditIcon'];
    cashAccount = MainIconPaths.fromJson(json['cashAccount']);
    properties = MainIconPaths.fromJson(json['properties']);
    vechicles = MainIconPaths.fromJson(json['vechicles']);
    investments = MainIconPaths.fromJson(json['investments']);
    pensions = MainIconPaths.fromJson(json['pensions']);
    cryptoCurrency = MainIconPaths.fromJson(json['cryptoCurrency']);
    stockBonds = MainIconPaths.fromJson(json['stockBonds']);
    customAssets = MainIconPaths.fromJson(json['customAssets']);
  }
}

class LiabilityPaths {
  String? drawerIcon;
  String? mainIcons;
  MainIconPaths? mortgages;
  MainIconPaths? creditCards;
  MainIconPaths? vehicleLoans;
  MainIconPaths? personalLoans;
  MainIconPaths? customLiabilities;

  LiabilityPaths(
      {this.drawerIcon,
      this.mainIcons,
      this.mortgages,
      this.creditCards,
      this.vehicleLoans,
      this.personalLoans,
      this.customLiabilities});

  LiabilityPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
    mainIcons = json['mainIcons'];
    mortgages = MainIconPaths.fromJson(json['mortgages']);
    creditCards = MainIconPaths.fromJson(json['creditCards']);
    vehicleLoans = MainIconPaths.fromJson(json['vehicleLoans']);
    personalLoans = MainIconPaths.fromJson(json['personalLoans']);
    customLiabilities = MainIconPaths.fromJson(json['customLiabilities']);
  }
}

class MyAccountPaths {
  String? drawerIcon;
  String? editIcon;
  MyAccountPaths({this.drawerIcon, this.editIcon});

  MyAccountPaths.fromJson(Map<String, dynamic> json) {
    drawerIcon = json['drawerIcon'];
    editIcon = json['editIcon'];
  }
}

class MainIconPaths {
  String? mainIcon;
  String? secondaryIcon;

  MainIconPaths({
    this.mainIcon,
    this.secondaryIcon,
  });

  MainIconPaths.fromJson(Map<String, dynamic> json) {
    mainIcon = json['mainIcon'] ?? "";
    secondaryIcon = json['secondaryIcon'] ?? "";
  }
}
