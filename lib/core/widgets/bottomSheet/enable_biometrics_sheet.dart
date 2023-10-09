import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/biometrics_auth.dart';
import 'package:wedge/core/widgets/buttons/bottom_button_widget.dart';
import 'package:wedge/core/widgets/dialog/wedge_new_custom_dialog_box.dart';
import 'package:wedge/dependency_injection.dart';

import '../../utils/wedge_func_methods.dart';

class EnableBioMetricSheet extends StatefulWidget {
  const EnableBioMetricSheet({super.key});

  @override
  State<EnableBioMetricSheet> createState() => _EnableBioMetricSheetState();
}

class _EnableBioMetricSheetState extends State<EnableBioMetricSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: size.height * .04, bottom: size.height * .03),
            child: SvgPicture.asset(BioMetricsAuth.biometricTypeImage,
                width: size.height * .09),
          ),
          Text(
            "Make logging in faster with\n${BioMetricsAuth.biometricTypeEnabled}",
            style: TitleHelper.h9.copyWith(color: appThemeColors!.textDark),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * .02, vertical: size.height * .005),
            child: Text(
              "For increased security and easy use of the Hoxton App, we would suggest to enable ${BioMetricsAuth.biometricTypeEnabled}.",
              style: SubtitleHelper.h11.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          SizedBox(
              width: double.infinity,
              child: WedgeButton(
                  text: "Enable",
                  padding: const EdgeInsets.all(10),
                  onPressed: () async {
                    if (await BioMetricsAuth().checkIfDeviceHasBiometrics()) {
                      locator<SharedPreferences>().setBool(
                          RootApplicationAccess
                              .didShowDeviceBioMetricBottomSheet,
                          true);
                      Navigator.pop(context);
                      locator<SharedPreferences>().setBool(
                          RootApplicationAccess
                              .isUserBioMetricIsEnabledPreference,
                          true);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async {
                              // Return false to restrict the back button when the dialog is visible
                              return false;
                            },
                            child: NewCustomDialogBox(
                              isSuccess: true,
                              onPressedPrimary: () async {
                                Navigator.pop(context);
                              },
                              title: 'Biometrics enabled',
                              primaryButtonText: "Continue",
                              description:
                                  'You have successfully enabled biometrics for Hoxton app.',
                            ),
                          );
                        },
                      );
                    } else {
                      Navigator.pop(context);
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return WillPopScope(
                            onWillPop: () async {
                              // Return false to restrict the back button when the dialog is visible
                              return false;
                            },
                            child: NewCustomDialogBox(
                              isSuccess: false,
                              onPressedPrimary: () {
                                Navigator.pop(context);
                              },
                              title: 'Biometrics Not Enabled',
                              primaryButtonText: "Continue",
                              showWarningIcon: true,
                              description:
                                  'Please enable biometrics on your mobile device to start using biometrics login on the Hoxton App.',
                            ),
                          );
                        },
                      );
                    }
                  })),
          TextButton(
              onPressed: () {
                locator<SharedPreferences>().setBool(
                    RootApplicationAccess.didShowDeviceBioMetricBottomSheet,
                    true);
                Navigator.pop(context);
              },
              child: Text(
                "Skip",
                style: SubtitleHelper.h10.copyWith(
                    color: appThemeColors!.primary,
                    fontWeight: FontWeight.w500),
              )),
          SizedBox(
            height: size.height * .015,
          ),
        ],
      ),
    );
  }
}
