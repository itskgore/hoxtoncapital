import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/helpers/navigators.dart';

class AddMoreTextButton extends StatelessWidget {
  final page;
  const AddMoreTextButton({Key? key, this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          cupertinoNavigator(
              context: context, screenName: page, type: NavigatorType.PUSH);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "${appIcons.addMoreButton}",
              width: 30.0,
              height: 30.0,
            ),
            const SizedBox(
              width: 6.0,
            ),
            Text(
              "Add More",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: kfontMedium,
                  fontFamily: appThemeHeadlineFont),
            ),
          ],
        ));
  }
}
