import 'dart:async';
import 'dart:developer';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:wedge/dependency_injection.dart';

import '../config/enviroment_config.dart';

class AppAnalytics {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> trackEvent(
      {required String eventName,
      required Map<String, dynamic> parameters}) async {
    if (enableMixpanel) {
      locator<Mixpanel>().track(eventName, properties: parameters);
    }
    Amplitude.getInstance().logEvent(eventName, eventProperties: parameters);
    _analytics.logEvent(name: eventName, parameters: parameters).then((value) {
      log(eventName.toString(), name: "Event Tracked");
    });
  }

  Future<void> trackLogin({
    required String userId,
    required String loginType,
    required String email,
  }) async {
    var parameter = {'userId': userId, "loginType": loginType, "email": email};
    String eventName = "login_event";
    AppAnalytics().trackEvent(eventName: eventName, parameters: parameter);
  }

  //TODO: @Karan screen track no longer required
  Future<void> trackScreen(
      {required String screenName, Map<String, dynamic>? parameters}) async {
    // final result = locator<SharedPreferences>()
    //     .getString(RootApplicationAccess.userPreferences);
    // if (result != null) {
    //   final data = UserPreferencesModel.fromJson(json.decode(result));
    //   parameters!['userId'] = data.pseudonym;
    //   locator<Mixpanel>().track("Page view", properties: parameters);
    //   Amplitude.getInstance()
    //       .logEvent('Page view', eventProperties: parameters);
    //   _analytics
    //       .logEvent(name: "screen_view", parameters: parameters)
    //       .then((value) {});
    //   _analytics.setCurrentScreen(screenName: screenName);
    // }
  }
}
