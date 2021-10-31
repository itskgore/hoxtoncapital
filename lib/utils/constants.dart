import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

bool isIOS() => Platform.isIOS ? true : false;

EdgeInsets getAppHorizontalPadding() => EdgeInsets.symmetric(horizontal: 20);

SizedBox buildHeightBox(BuildContext context, double heightPer) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * heightPer,
  );
}

SizedBox buildHeightBoxNormal(BuildContext context, double heightPer) {
  return SizedBox(
    height: heightPer,
  );
}

SizedBox buildWidthBox(BuildContext context, double widthPer) {
  return SizedBox(
    width: MediaQuery.of(context).size.height * widthPer,
  );
}

SizedBox buildWidthBoxNormal(BuildContext context, double widthPer) {
  return SizedBox(
    width: widthPer,
  );
}

double getHeightWidth(BuildContext context, bool height) {
  if (height) {
    return MediaQuery.of(context).size.height;
  } else {
    return MediaQuery.of(context).size.width;
  }
}

Shimmer buildShimmerContainer(ThemeData theme, BuildContext context) {
  return Shimmer.fromColors(
      baseColor: theme.buttonColor,
      highlightColor: theme.primaryColorLight,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: getHeightWidth(context, true) * 0.30,
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(20)),
      ));
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
