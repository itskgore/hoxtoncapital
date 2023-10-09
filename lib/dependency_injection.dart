// ignore_for_file: cascade_invocations

import 'package:get_it/get_it.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_icons.dart';
import 'package:wedge/core/widgets/dialog/custom_dialog.dart';
import 'package:wedge/service_registration/register_blocs.dart';
import 'package:wedge/service_registration/register_data_sources.dart';
import 'package:wedge/service_registration/register_repositories.dart';
import 'package:wedge/service_registration/register_usecases.dart';

import 'core/data_models/theme_model.dart';

GetIt locator = GetIt.instance;

Future<void> setupServicesLocator({String? mixpanelKey}) async {
  /// register all the call flow with the service locator
  /// bloc => usecase => repository => datasource
  RegisterBlocs();
  RegisterUseCases();
  RegisterRepository();
  RegisterDataSources();

  //external
  final sharedPreferencesInstance = SharedPreferences.getInstance();
  final SharedPreferences sharedPreferences = await sharedPreferencesInstance;
  locator.registerLazySingleton(() => sharedPreferences);

  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  locator.registerLazySingleton(() => packageInfo);

  locator.registerLazySingleton<WedgeDialog>(() => WedgeDialogImpl());

  AppTheme appTheme = AppTheme();
  locator.registerLazySingleton(() => appTheme);

  AppIcons appIcons = AppIcons();
  locator.registerLazySingleton(() => appIcons);

  // mixpanel
  Mixpanel mixpanel = await Mixpanel.init(
      mixpanelKey ?? "ffa6ae1e2eb8fc8c67825dbc987d489e", // prod
      optOutTrackingDefault: false,
      trackAutomaticEvents: true);
  locator.registerLazySingleton(() => mixpanel);
  // locator.registerLazySingleton(() => AppLocalizations.of(context));
}
