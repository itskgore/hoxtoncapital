import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wedge/core/config/app_config.dart';

class AddNewButton extends StatelessWidget {
  final String? icon;
  final String text;
  final Function onTap;
  final double? IconHeight;
  final double? IconWidth;
  const AddNewButton(
      {Key? key,
      required this.text,
      required this.onTap,
      this.icon,
      this.IconHeight,
      this.IconWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon ?? "${appIcons.addMoreButton}",
              width: IconWidth ?? 30.0,
              height: IconHeight ?? 30.0,
            ),
            const SizedBox(
              width: 6.0,
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: appThemeSubtitleFont,
                color: appThemeColors!.outline,
                fontSize: appThemeHeadlineSizes!.h10,
              ),
            ),
          ],
        ));
  }
}
