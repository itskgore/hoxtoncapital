import '../../dependency_injection.dart';
import '../data_models/theme_model.dart';

String _baseUrl = "";
String _baseUrl2 = '';
String _authBaseUrl = "";
String _webBaseUrl = "";
String _loginUrl = "";
String _forgotPasswordUrl = "";
String _validateOtpUrl = "";
String _resendOtpUrl = "";
String _env = "";
bool _enableMixpanel = false;
bool _enableUserReferral = false;
List<NewFeatureModel> _newFeatures = [];

//Environment
void setUpEnvironment(AppEnviroment env) {
  env.setEnvironment();
}

String get apiBaseUrl => _baseUrl;

String get apiBaseUrl2 => _baseUrl2;

String get webBaseUrl => _webBaseUrl;

String get authBaseUrl => _authBaseUrl;

String get loginUrl => _loginUrl;

String get forgotPasswordUrl => _forgotPasswordUrl;

String get validateOtpUrl => _validateOtpUrl;

String get resendOtpUrl => _resendOtpUrl;

String get env => _env;

bool get enableMixpanel => _enableMixpanel;

bool get enableUserReferral => _enableUserReferral;

List<NewFeatureModel> get newFeatures => _newFeatures;

abstract class AppEnviroment {
  setEnvironment();
}

class MockEnviroment extends AppEnviroment {
  @override
  setEnvironment() {
    _baseUrl = locator<AppTheme>().apiUrls!.baseUrl!.mock!;
    _baseUrl2 = locator<AppTheme>().apiUrls!.baseUrl2!.mock!;
    _webBaseUrl = locator<AppTheme>().apiUrls!.webUrls!.mock!;
    _loginUrl = locator<AppTheme>().apiUrls!.auth!.login!.mock!;
    _forgotPasswordUrl =
        locator<AppTheme>().apiUrls!.auth!.forgotPassword!.mock!;
    _validateOtpUrl = locator<AppTheme>().apiUrls!.auth!.validateOtp!.mock!;
    _resendOtpUrl = locator<AppTheme>().apiUrls!.auth!.reSendOtp!.mock!;
    _authBaseUrl = locator<AppTheme>().apiUrls!.auth!.baseUrl!.mock!;
    _newFeatures = locator<AppTheme>().newFeatures!;
    _env = "-mock";
  }
}

class StageEnviroment extends AppEnviroment {
  @override
  setEnvironment() {
    _baseUrl = locator<AppTheme>().apiUrls!.baseUrl!.stage!;
    _baseUrl2 = locator<AppTheme>().apiUrls!.baseUrl2!.stage!;
    _webBaseUrl = locator<AppTheme>().apiUrls!.webUrls!.stage!;

    _loginUrl = locator<AppTheme>().apiUrls!.auth!.login!.stage!;
    _forgotPasswordUrl =
        locator<AppTheme>().apiUrls!.auth!.forgotPassword!.stage!;
    _validateOtpUrl = locator<AppTheme>().apiUrls!.auth!.validateOtp!.stage!;
    _resendOtpUrl = locator<AppTheme>().apiUrls!.auth!.reSendOtp!.stage!;
    _authBaseUrl = locator<AppTheme>().apiUrls!.auth!.baseUrl!.stage!;
    _enableMixpanel = locator<AppTheme>().featureFlag!.stage.enableMixpanel;
    _enableUserReferral =
        locator<AppTheme>().featureFlag!.stage.enableUserReferral;
    _newFeatures = locator<AppTheme>().newFeatures!;
    _env = "-stage";
  }
}

class QAEnviroment extends AppEnviroment {
  @override
  setEnvironment() {
    _baseUrl = locator<AppTheme>().apiUrls!.baseUrl!.qa!;
    _baseUrl2 = locator<AppTheme>().apiUrls!.baseUrl2!.qa!;
    _webBaseUrl = locator<AppTheme>().apiUrls!.webUrls!.qa!;
    _loginUrl = locator<AppTheme>().apiUrls!.auth!.login!.qa!;
    _forgotPasswordUrl = locator<AppTheme>().apiUrls!.auth!.forgotPassword!.qa!;
    _validateOtpUrl = locator<AppTheme>().apiUrls!.auth!.validateOtp!.qa!;
    _resendOtpUrl = locator<AppTheme>().apiUrls!.auth!.reSendOtp!.qa!;
    _authBaseUrl = locator<AppTheme>().apiUrls!.auth!.baseUrl!.qa!;
    _enableMixpanel = locator<AppTheme>().featureFlag!.qa.enableMixpanel;
    _enableUserReferral =
        locator<AppTheme>().featureFlag!.qa.enableUserReferral;
    _newFeatures = locator<AppTheme>().newFeatures!;
    _env = "-qa";
  }
}

class ProdEnviroment extends AppEnviroment {
  @override
  setEnvironment() {
    _baseUrl = locator<AppTheme>().apiUrls!.baseUrl!.prod!;
    _baseUrl2 = locator<AppTheme>().apiUrls!.baseUrl2!.prod!;
    _webBaseUrl = locator<AppTheme>().apiUrls!.webUrls!.prod!;
    _loginUrl = locator<AppTheme>().apiUrls!.auth!.login!.prod!;
    _forgotPasswordUrl =
        locator<AppTheme>().apiUrls!.auth!.forgotPassword!.prod!;
    _validateOtpUrl = locator<AppTheme>().apiUrls!.auth!.validateOtp!.prod!;
    _resendOtpUrl = locator<AppTheme>().apiUrls!.auth!.reSendOtp!.prod!;
    _authBaseUrl = locator<AppTheme>().apiUrls!.auth!.baseUrl!.prod!;
    _enableMixpanel = locator<AppTheme>().featureFlag!.prod.enableMixpanel;
    _enableUserReferral =
        locator<AppTheme>().featureFlag!.prod.enableUserReferral;
    _newFeatures = locator<AppTheme>().newFeatures!;
    _env = "";
  }
}
