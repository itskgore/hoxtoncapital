import 'package:amplitude_flutter/amplitude.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/enviroment_config.dart';

import 'core/config/company_config.dart';
import 'core/config/notification_config.dart';
import 'dependency_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServicesLocator(mixpanelKey: "9b37daf46b34b00539ec3f4f706f84ad");
  await Firebase.initializeApp();
  setCompany(HoxtonCapital());
  setUpEnvironment(QAEnviroment());
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  initFirebaseMessaging();
  Amplitude.getInstance().init("b3895c7a7ef3a01a231f3009bba62365");
  runApp(const App());
}
