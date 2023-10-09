import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/app_passcode/confirm_passcode/presentation/pages/confirm_passcode_screen.dart';

import '../../../../config/app_config.dart';
import '../../../../utils/wedge_func_methods.dart';

class BioMetricsBgScreen extends StatelessWidget {
  final double? logoOpacity;
  final String userName;
  final bool isFromSplash;
  bool shouldShowBioMetric;
  final String userData;
  BioMetricsBgScreen(
      {Key? key,
      this.logoOpacity,
      required this.userName,
      required this.userData,
      required this.shouldShowBioMetric,
      required this.isFromSplash})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // shouldShowBioMetric = true;
    return WillPopScope(
      onWillPop: () async {
        exit(0);
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: appThemeColors!.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: isSmallDevice(context)
                        ? shouldShowBioMetric
                            ? 30
                            : 20
                        : 60,
                  ),
                  Hero(
                    tag: 'logoimage',
                    child: Image.asset(
                      "assets/images/hoxton_logo.png",
                      width: isSmallDevice(context)
                          ? shouldShowBioMetric
                              ? 100.0
                              : 150.0
                          : 150,
                      // height: shouldShowBioMetric ? 100.0 : 120.0,
                    ),
                  ),
                  SizedBox(
                    height: shouldShowBioMetric ? 10 : 20,
                  ),
                  // Hero(
                  //   tag: 'logoimage',
                  //   child: Opacity(
                  //     opacity: logoOpacity ?? 1,
                  //     child: WedgeLogo(
                  //       width: shouldShowBioMetric ? 100.0 : 150.0,
                  //       height: shouldShowBioMetric ? 100.0 : 120.0,
                  //       darkLogo: false,
                  //     ),
                  //   ),
                  // ),
                  Text(
                    "Welcome Back!",
                    style: shouldShowBioMetric
                        ? TitleHelper.h11
                            .copyWith(color: appThemeColors!.textLight)
                        : TitleHelper.h10
                            .copyWith(color: appThemeColors!.textLight),
                  ),
                  Text(
                    userName,
                    style: shouldShowBioMetric
                        ? SubtitleHelper.h12
                            .copyWith(color: appThemeColors!.textLight)
                        : SubtitleHelper.h11
                            .copyWith(color: appThemeColors!.textLight),
                  ),
                ],
              ),
              SizedBox(
                height: isSmallDevice(context) ? 10 : 30,
              ),
              ConfirmPasscodeScreen(
                shouldShowBioMetric: shouldShowBioMetric,
                userData: userData,
                isFromSplash: isFromSplash,
                email: locator<SharedPreferences>().getString(
                        RootApplicationAccess.passCodeMailPreferences) ??
                    "",
              )
            ],
          ),
        ),
      ),
    );
  }
}
