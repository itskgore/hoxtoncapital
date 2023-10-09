import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;
import 'package:upgrader/upgrader.dart';
import 'package:wedge/app.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/utils/wedge_snackBar.dart';
import 'package:wedge/core/widgets/bank_success_bank_data_placeholder.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/assets/all_assets/presentation/bloc/cubit/allassets_cubit.dart';
import 'package:wedge/features/auth/hoxton_login/data/models/login_model.dart';
import 'package:wedge/features/liabilities/add_liabilities_page/presentation/bloc/add_liabilities_page_cubit.dart';

import 'countries.dart';

//responsive size

Size size = MediaQuery.of(navigatorKey.currentState!.context).size;
var translate = AppLocalizations.of(navigatorKey.currentState!.context);

Widget getLeadingIcon(BuildContext context, bool isAssets) {
  return IconButton(
      onPressed: () {
        // Refreshing Data OnBackPress
        refreshMainState(context: context, isAsset: isAssets);
        Navigator.pop(context, "");
      },
      icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios));
}

Widget getLeadingNormalIcon({required BuildContext context}) {
  return IconButton(
      onPressed: () {
        Navigator.pop(context, "");
      },
      icon: Icon(Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios));
}

refreshMainState({required BuildContext context, required bool isAsset}) {
  if (isAsset) {
    BlocProvider.of<AllAssetsCubit>(
      context,
    ).getData();
  } else {
    BlocProvider.of<AddLiabilitiesPageCubit>(
      context,
    ).getMainLiabilities();
  }
}

Future<bool> isConnectedToInternetData() async {
  bool result = await InternetConnectionChecker().hasConnection;
  return result;
}

requestAccess(BuildContext context, {String? title, String? subTitle}) {
  showSnackBar(context: context, title: translate!.photoAccessPermissionGuide);
}

getCountryISO3fromName(String name) {
  try {
    String countryISO = CountriesWithCodes().countriesWithCode.firstWhere(
        (element) =>
            element['country'].toLowerCase() == name.toLowerCase())['alpha3'];
    return countryISO;
  } catch (e) {
    return name;
  }
}

getCountryNameFromISO3({required String name, bool isTrim = true}) {
  try {
    String country = CountriesWithCodes().countriesWithCode.firstWhere(
        (element) =>
            element['alpha3'].toLowerCase() == name.toLowerCase())['country'];
    if (country.length > 14 && isTrim) {
      return "${country.substring(0, 13)}...";
    } else {
      return country;
    }
  } catch (e) {
    return name;
  }
}

getFullCountryNameFromISO3(String name) {
  try {
    String country = CountriesWithCodes().countriesWithCode.firstWhere(
        (element) =>
            element['alpha3'].toLowerCase() == name.toLowerCase())['country'];
    return country;
  } catch (e) {
    return name;
  }
}

getCurrencyNamefromISO3(String name) {
  try {
    String country = CountriesWithCodes().countriesWithCode.firstWhere(
            (element) => element['alpha3'].toLowerCase() == name.toLowerCase())[
        'currencyCode'];
    if (country.length > 14) {
      return "${country.substring(0, 13)}...";
    } else {
      return country;
    }
  } catch (e) {
    return name;
  }
}

setCrashlytics() async {
  final result = locator<SharedPreferences>()
      .getString(RootApplicationAccess.userPreferences);
  if (result != null) {
    final data = UserPreferencesModel.fromJson(json.decode(result));
    FirebaseCrashlytics.instance.setCustomKey('userPseudonym', data.pseudonym);
  }
}

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("dd-MM-yyyy h:mma").parse(dateString).toUtc();
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

bool isSmallDevice(BuildContext context) {
  return MediaQuery.of(context).size.height <= 700;
}

Expanded passcodeLoader() {
  return Expanded(
    child: GridView.builder(
      shrinkWrap: true,
      itemCount: 12,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 12,
          mainAxisSpacing: 10,
          childAspectRatio: 1.7,
          crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.black54,
          highlightColor: Colors.grey.withOpacity(0.2),
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(6)),
              child: Text(
                "",
                style: TitleHelper.h8,
              )),
        );
      },
    ),
  );
}

bankAccountDataLoader() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.withOpacity(0.2),
    child: const BankDataPlaceHolder(),
  );
}

class MyEnglishMessages extends UpgraderMessages {
  /// Override the message function to provide custom language localization.
  @override
  String message(UpgraderMessage messageKey) {
    switch (messageKey) {
      case UpgraderMessage.body:
        return '\nA new version of {{appName}} {{currentAppStoreVersion}} is available!';
      case UpgraderMessage.buttonTitleIgnore:
        return '';
      case UpgraderMessage.buttonTitleLater:
        return '';
      case UpgraderMessage.buttonTitleUpdate:
        return translate!.update;
      case UpgraderMessage.prompt:
        return translate!.upgradeToNewVersion;
      case UpgraderMessage.releaseNotes:
        return '';
      case UpgraderMessage.title:
        return '${translate!.update} ${translate!.now}!';
    }
    // Messages that are not provided above can still use the default values.
  }
}

Future _getStoragePermission() async {
  await [
    Permission.storage,
    Permission.manageExternalStorage,
    Permission.accessMediaLocation
  ].request();
}

// get Permission based on device and sdk
Future<bool> getPermission() async {
  late final Map<Permission, PermissionStatus> statusess;
  var allAccepted = true;

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt <= 32) {
      statusess = await [Permission.storage].request();
    } else {
      statusess = await [Permission.photos].request();
    }
  } else {
    statusess = await [Permission.storage].request();
  }

  statusess.forEach((permission, status) {
    if (status != PermissionStatus.granted) {
      allAccepted = false;
    }
  });
  return allAccepted;
}

Future<void> exportTextAsCSV(List<Map<String, dynamic>> data) async {
  try {
    if (data.isEmpty) {
      showSnackBar(
          context: navigatorKey.currentState!.context,
          title: translate!.transactionDataUnavailable);
      return;
    }
    _getStoragePermission();
    List<String> header = [];
    header.addAll(data.first.keys.toList());
    List<List<dynamic>> convertedList = data.map((map) {
      return map.values.toList();
    }).toList();
    List<List<String>> stringList = convertedList.map((innerList) {
      return innerList.map((item) => item.toString()).toList();
    }).toList();
    stringList.insert(0, header);
    exportCSV.myCSV(header, stringList);
  } catch (e) {
    showSnackBar(context: navigatorKey.currentState!.context, title: "$e");
  }
}

openSettingsForStorage() {
  showSnackBar(
      context: navigatorKey.currentState!.context,
      title:
          translate!.yourPermissionIsPermanentlyDeniedPleaseEnableFromSettings);
  Future.delayed(
      const Duration(
        seconds: 2,
      ), () async {
    await openAppSettings();
  });
}

DateTime getDateTimeOnly({required DateTime datetime}) {
  return DateTime(datetime.year, datetime.month, datetime.day);
}

String? getUserNameFromAccessToken() {
  final userData = locator<SharedPreferences>()
          .getString(RootApplicationAccess.loginUserPreferences) ??
      "";
  if (userData.isNotEmpty) {
    final userAccessTokenData =
        Jwt.parseJwt(LoginModel.fromJson(json.decode(userData)).accessToken);
    locator<SharedPreferences>().setString(
        RootApplicationAccess.usernameFullNamePreferences,
        "${userAccessTokenData['firstName']} ${userAccessTokenData['lastName']}");
    return userAccessTokenData['firstName'];
  } else {
    return "";
  }
}

bool getIsUserInOnBoardingState() {
  final userData = LoginModel.fromJson(jsonDecode(locator<SharedPreferences>()
          .getString(RootApplicationAccess.loginUserPreferences) ??
      ""));
  return userData.isOnboardingCompleted == false;
}
