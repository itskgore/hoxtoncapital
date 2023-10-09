import 'package:wedge/core/config/privacy_policy_html.dart';
import 'package:wedge/core/config/term_condition_html.dart';

Map<String, dynamic> wedgeTheme = {
  "clientName": "Wedge",
  "singleLoginFlow": true,
  "hasMyServices": false,
  "termsCondition": TermAndConditionHtml().data,
  "privacyPolicy": PrivacyPolicyHtml().data,
  "apiUrls": {
    "baseUrl": {
      "prod": "https://api.getwedge.com/facade",
      "qa": "https://api-qa.getwedge.com/facade",
      "stage": "https://api-stage.getwedge.com/facade",
      "mock": "https://api.getwedge.com/mock-server/api/v1",
    },
    "webUrls": {
      "prod": "http://portal.getwedge.com/",
      "qa": "https://portal-qa.getwedge.com/",
      "stage": "https://portal-stage.getwedge.com/",
      "mock": "https://hoxton-qa.getwedge.com/",
    },
    "auth": {
      "baseUrl": {
        "qa": "https://testing-wedge-mat.hoxtoncrm.com/api/mobile/",
        "prod": "https://login.hoxtonclientportal.com/api/mobile/",
        "stage": "https://testing-wedge-mat.hoxtoncrm.com/api/mobile/",
        "mock": "https://testing-wedge-mat.hoxtoncrm.com/api/mobile/",
      },
      "validateOtp": {
        "qa":
            "https://testing-wedge-mat.hoxtoncrm.com/api/sso/mobile/validate-two-factor-code",
        "prod":
            "https://login.hoxtonclientportal.com/api/sso/mobile/validate-two-factor-code",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/sso/mobile/validate-two-factor-code",
        "mock":
            "https://testing-wedge-mat.hoxtoncrm.com/api/api/sso/mobile/validate-two-factor-code",
      },
      "reSendOtp": {
        "qa": "https://testing-wedge-mat.hoxtoncrm.com/api/api/sso/resend-code",
        "prod": "https://login.hoxtonclientportal.com/api/sso/resend-code",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/sso/resend-code",
        "mock":
            "https://testing-wedge-mat.hoxtoncrm.com/api/api/sso/resend-code",
      },
      "login": {
        "qa": "https://api-qa.getwedge.com/facade/identity/v1/auth/login",
        "prod": "https://api.getwedge.com/facade/identity/v1/auth/login",
        "stage": "https://api-stage.getwedge.com/facade/identity/v1/auth/login",
        "mock":
            "https://api.getwedge.com/mock-server/api/v1/identity/v1/auth/login",
      },
      "forgotPassword": {
        "qa": "https://api-qa.getwedge.com/facade/identity/v1/auth/reset",
        "prod": "https://api.getwedge.com/facade/identity/v1/auth/reset",
        "stage": "https://api-stage.getwedge.com/facade/identity/v1/auth/reset",
        "mock":
            "https://api.getwedge.com/mock-server/api/v1/identity/v1/auth/reset",
      }
    },
  },
  "appImages": {
    "appLogoLight": "assets/images/logo.png",
    "appLogoDark": "assets/images/logo_dark.png",
  },
  "colors": {
    "primary": "#11403A",
    "loginColorTheme": {
      "bgColor": "#11403A",
      "buttonColor": "#000000",
      "textTitleColor": "#FFFFFF",
      "textSubtitleColor": "#767B9D",
      "textFieldFillColor": "#0E3833",
      "textFieldPlaceholderColor": "#FFFFFF",
      "textFieldTextStyle": "#000000",
      "darkLogo": false,
    },
    "gradient": ["#11403A", "#11403A"],
    "bg": "#F7F8F0",
    "textLight": "#ffffff",
    "textDark": "#000000",
    "buttonText": "#ffffff",
    "outline": "#428DFF", //428DFF
    "disableDark": "#CFCFCF",
    "disableLight": "#EAEBE1",
    "disableText": "#4F4F4F",
    "buttonLight": "#EAEBE1",

    "creditCards": [
      ["#ffeec3", "#f9f0d0"],
      ["#40d4b1", "#cff5ea"],
      ["#b5d3ef", "#d1e6fa"],
      ["#f3eeff", "#dcc8ec"]
    ],
    "charts": {
      "lineCharts": {
        "line": "#428DFF",
        "mainChartLineColor": "#51AF86",
        "defualtChartLineColor": "#222A62"
      },
      "barCharts": {
        "positive": "#51AF86",
        "negative": "#F47373",
      },
      "calculatorCharts": {"recommended": "#428DFF", "currentPath": "#616161"},
      "assets": {
        "mainAsset": "#51AF86",
        "cashAccount": "#FFE07D",
        "properties": "#F99664",
        "vehicles": "#51AF86",
        "investment": "#FF8686",
        "pensions": "#428DFF",
        "crypto": "#4F4F4F",
        "stocks": "#C09CCA",
        "customAssets": "#B6B211",
        "progressLineColor": "#51AF86",
      },
      "liabilties": {
        "mainLiability": "#F47373",
        "mortgages": "#FFE07D",
        "creditCards": "#F99664",
        "vehicleLoans": "#51AF86",
        "personLoans": "#FF8686",
        "customLiabilities": "#428DFF",
        "progressLineColor": "#F47373",
      }
    }
  },
  "fonts": {
    "genericFont": "Roboto",
    "headline": {
      "isBold": false,
      "font": "Roboto",
      "sizes": {
        "h1": 32.0,
        "h2": 30.0,
        "h3": 28.0,
        "h4": 26.0,
        "h5": 24.0,
        "h6": 22.0,
        "h7": 21.0,
        "h8": 20.0,
        "h9": 18.0,
        "h10": 16.0,
        "h11": 14.0,
        "h12": 12.0,
      }
    },
    "subtitle": {
      "font": "Roboto",
      "sizes": {
        "h1": 32.0,
        "h2": 30.0,
        "h3": 28.0,
        "h4": 26.0,
        "h5": 24.0,
        "h6": 22.0,
        "h7": 21.0,
        "h8": 20.0,
        "h9": 18.0,
        "h10": 16.0,
        "h11": 14.0,
        "h12": 12.0,
      }
    },
  }
};

Map<String, dynamic> hoxtonTheme = {
  "clientName": "Hoxton",
  "singleLoginFlow": false,
  "hasMyServices": true,
  "termsCondition": TermAndConditionHtml().data,
  "privacyPolicy": PrivacyPolicyHtml().data,
  "featureFlag": {
    "qa": {"enableMixpanel": false, "enableUserReferral": false},
    "stage": {"enableMixpanel": false, "enableUserReferral": false},
    "prod": {"enableMixpanel": true, "enableUserReferral": false},
  },
  "newFeatures": [
    {'name': "Invite Friends", 'launchDate': '10-9-2023', 'DurationDays': '30'}
  ],
  "apiUrls": {
    "baseUrl": {
      "prod": "https://api.getwedge.com/facade",
      "qa": "https://api-qa.getwedge.com/facade",
      "stage": "https://api-stage.getwedge.com/facade",
      "mock": "https://api.getwedge.com/mock-server/api/v1",
    },
    "baseUrl2": {
      "qa": "https://testing-wedge-mat.hoxtoncrm.com/api/",
      "prod": "https://login.hoxtonclientportal.com/api/",
      "stage": "https://staging-wedge-mat.hoxtonclientportal.com/api/",
      "mock": "https://testing-wedge-mat.hoxtoncrm.com/api/api/",
    },
    "webUrls": {
      "prod": "https://hoxton.getwedge.com/",
      "qa": "https://hoxton-qa.getwedge.com/",
      "stage": "https://hoxton-stage.getwedge.com/",
      "mock": "https://hoxton-qa.getwedge.com/",
    },
    "auth": {
      "baseUrl": {
        "qa": "https://testing-wedge-mat.hoxtoncrm.com/api/sso/mobile/",
        "prod": "https://login.hoxtonclientportal.com/api/sso/mobile/",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/sso/mobile/",
        "mock": "https://testing-wedge-mat.hoxtoncrm.com/api/api/sso/mobile/",
      },
      "validateOtp": {
        "qa":
            "https://testing-wedge-mat.hoxtoncrm.com/api/sso/mobile/validate-two-factor-code",
        "prod":
            "https://login.hoxtonclientportal.com/api/sso/mobile/validate-two-factor-code",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/sso/mobile/validate-two-factor-code",
        "mock":
            "https://testing-wedge-mat.hoxtoncrm.com/api/api/sso/mobile/validate-two-factor-code",
      },
      "reSendOtp": {
        "qa": "https://testing-wedge-mat.hoxtoncrm.com/api/sso/resend-code",
        "prod": "https://login.hoxtonclientportal.com/api/sso/resend-code",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/sso/resend-code",
        "mock":
            "https://testing-wedge-mat.hoxtoncrm.com/api/api/sso/resend-code",
      },
      "login": {
        "qa": "https://testing-wedge-mat.hoxtoncrm.com/api/sso/mobile/login",
        "prod": "https://login.hoxtonclientportal.com/api/sso/mobile/login",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/sso/mobile/login",
        "mock": "https://testing-wedge-mat.hoxtoncrm.com/api/sso/mobile/login",
      },
      "forgotPassword": {
        "qa":
            "https://testing-wedge-mat.hoxtoncrm.com/api/mobile/forgot-password",
        "prod":
            "https://login.hoxtonclientportal.com/api/mobile/forgot-password",
        "stage":
            "https://staging-wedge-mat.hoxtonclientportal.com/api/mobile/forgot-password",
        "mock":
            "https://testing-wedge-mat.hoxtoncrm.com/api/mobile/forgot-password",
      }
    },
    "endPoints": {
      "fiancialInformationEndpoint": "/financial-information/v1",
      "identitynEndpoint": "/identity/v1",
      "notificationEndPoint": "/notification/v1",
      "userPreferenceEndpoint": "/user-preference/v1",
      "insightsEndpoint": "/insights/v1/",
      "documentValtEndPoint": "/documents/v1/"
    }
  },
  "appImages": {
    "appLogoLight": "assets/images/hoxtonlogo_light.png",
    "appLogoDark": "assets/images/hoxtonlogo_dark.png",
  },
  "colors": {
    "loginColorTheme": {
      "bgColor": "#F4F4F7",
      "buttonColor": "#222A62",
      "textTitleColor": "#222A62",
      "textSubtitleColor": "#767B9D",
      "textFieldFillColor": "#ffffff",
      "textFieldPlaceholderColor": "#4F4F4F",
      "textFieldTextStyle": "#000000",
      "darkLogo": true,
    },
    "primary": "#222A62",
    "gradient": ["#517FA2", "#222A62"],
    "bg": "#F4F4F7",
    "textLight": "#ffffff",
    "textDark": "#4F4F4F",
    "outline": "#428DFF",
    "disableDark": "#CFCFCF",
    "disableLight": "#EAEBE1",
    "buttonText": "#ffffff",
    "disableText": "#767B9D",
    "buttonLight": "#D3DDE6",
    "creditCards": [
      ["#ffeec3", "#f9f0d0"],
      ["#40d4b1", "#cff5ea"],
      ["#b5d3ef", "#d1e6fa"],
      ["#f3eeff", "#dcc8ec"]
    ],
    "charts": {
      "lineCharts": {
        "line": "#222A62",
        "mainChartLineColor": "#51AF86",
        "defualtChartLineColor": "#222A62"
      },
      "barCharts": {
        "positive": "#517FA2",
        "negative": "#D3DDE6",
      },
      "calculatorCharts": {"recommended": "#222A62", "currentPath": "#616161"},
      "assets": {
        "mainAsset": "#51AF86",
        "cashAccount": "#FFE07D",
        "properties": "#F99664",
        "vehicles": "#51AF86",
        "investment": "#FF8686",
        "pensions": "#428DFF",
        "crypto": "#4F4F4F",
        "stocks": "#C09CCA",
        "customAssets": "#B6B211",
        "progressLineColor": "#517FA2",
      },
      "liabilties": {
        "mainLiability": "#F47373",
        "mortgages": "#FFE07D",
        "creditCards": "#F99664",
        "vehicleLoans": "#51AF86",
        "personLoans": "#FF8686",
        "customLiabilities": "#428DFF",
        "progressLineColor": "#F47373",
      }
    }
  },
  "fonts": {
    "genericFont": "Roboto",
    "headline": {
      "isBold": true,
      "font": "Roboto",
      "sizes": {
        "h1": 32.0,
        "h2": 30.0,
        "h3": 28.0,
        "h4": 26.0,
        "h5": 24.0,
        "h6": 22.0,
        "h7": 21.0,
        "h8": 20.0,
        "h9": 18.0,
        "h10": 16.0,
        "h11": 14.0,
        "h12": 12.0,
      }
    },
    "subtitle": {
      "font": "Roboto",
      "sizes": {
        "h1": 32.0,
        "h2": 30.0,
        "h3": 28.0,
        "h4": 26.0,
        "h5": 24.0,
        "h6": 22.0,
        "h7": 21.0,
        "h8": 20.0,
        "h9": 18.0,
        "h10": 16.0,
        "h11": 14.0,
        "h12": 12.0,
      }
    },
  }
};
