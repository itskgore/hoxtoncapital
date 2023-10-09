import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';
import 'package:wedge/dependency_injection.dart';
import 'package:wedge/features/home/presentation/pages/home_page.dart';

class SkipToHome extends StatelessWidget {
  const SkipToHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // bool isEmpty = RootApplicationAccess.assetsEntity?.summary.types == 0;

    return Container(
      child: Column(
        children: [
          TextButton(
              onPressed: () {
                locator<SharedPreferences>()
                    .setBool(RootApplicationAccess.isSkippedPreference, true);
                locator<SharedPreferences>()
                    .setBool(RootApplicationAccess.firstLoginPreference, false);
                cupertinoNavigator(
                    context: context,
                    screenName: const HomePage(),
                    type: NavigatorType.PUSHREMOVEUNTIL);
              },
              child: Text(
                translate!.skipToHomeScreen,
                style: SubtitleHelper.h10.copyWith(
                    color: appThemeColors!.outline,
                    fontWeight: FontWeight.normal),
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              ADD_YOUR_FINANCIALDATA_MESSAGE,
              style: SubtitleHelper.h11.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
