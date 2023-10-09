import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/user_preferences_model.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wiredash/wiredash.dart';

import '../../dependency_injection.dart';

AppBar wedgeAppBar(
    {required BuildContext context,
    required String title,
    Widget? leadingIcon,
    Color? backgroundColor,
    PreferredSizeWidget? bottom,
    Widget? actions}) {
  return AppBar(
    backgroundColor: backgroundColor ?? appThemeColors!.bg,
    leading: leadingIcon ??
        (Navigator.canPop(context)
            ? getLeadingNormalIcon(context: context)
            : Container()),
    actions: [
      IconButton(
        onPressed: () {
          setUSerID(context);
          Wiredash.of(context).show();
        },
        icon: Image.asset(
          "assets/icons/wiredash.png",
          width: 20,
        ),
      ),
      actions ?? Container(),
    ],
    title: Text(
      title,
      style: appbarStyle(),
    ),
    bottom: bottom,
  );
}

TextStyle appbarStyle() {
  return TitleHelper.h8.copyWith(color: appThemeColors!.primary);
}

Widget getWireDashIcon(BuildContext context) {
  return IconButton(
      onPressed: () {
        setUSerID(context);
        Wiredash.of(context)!.show();
      },
      icon: Image.asset(
        "assets/icons/wiredash.png",
        width: 20,
      ));
}

setUSerID(context) {
  var userEmail;
  var userID;
  String res = locator<SharedPreferences>()
          .getString(RootApplicationAccess.emailUserPreferences) ??
      "";
  if (res != "") {
    userEmail = json.decode(res);
  }
  final result = locator<SharedPreferences>()
      .getString(RootApplicationAccess.userPreferences);
  if (result != null) {
    userID = UserPreferencesModel.fromJson(json.decode(result));
  }
  if (userEmail != null) {
    if (userID != null) {
      Wiredash.of(context)!.setUserProperties(
          userEmail: userEmail["email"] ?? "", userId: userID.pseudonym ?? "");
    }
  }

  Wiredash.of(context)!.setBuildProperties(
    buildNumber: locator<PackageInfo>().buildNumber,
    buildVersion: locator<PackageInfo>().version,
  );
}
