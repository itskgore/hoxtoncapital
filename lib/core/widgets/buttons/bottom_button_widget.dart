import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class WedgeButton extends StatelessWidget {
  WedgeButton(
      {required this.text,
      required this.onPressed,
      Key? key,
      this.buttonColor,
      this.padding,
      this.textColor})
      : super(key: key);

  String text;
  VoidCallback? onPressed;
  Color? buttonColor;
  Color? textColor;
  EdgeInsets? padding;
  @override
  Widget build(BuildContext context) => Container(
        padding: padding ?? const EdgeInsets.all(20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: buttonColor ?? appThemeColors!.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            fixedSize: const Size(0, 60),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontFamily: appThemeHeadlineFont,
              color: textColor ?? kfontColorLight,
              fontWeight: FontWeight.normal,
              letterSpacing: 1.1,
            ),
          ),
        ),
      );
}
