import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';

class WedgeLogo extends StatelessWidget {
  final width;
  final height;
  final darkLogo;
  const WedgeLogo({this.width, this.height, this.darkLogo});

  @override
  Widget build(BuildContext context) {
    if (darkLogo) {
      return Image.asset(
        appTheme.appImage!.appLogoDark!,
        width: width,
        height: height,
      );
    } else {
      return Image.asset(
        appTheme.appImage!.appLogoLight!,
        width: width,
        height: height,
      );
    }
  }
}
