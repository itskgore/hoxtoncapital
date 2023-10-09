import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';

Widget buildCircularProgressIndicator({double? width}) {
  return Center(
    child: Container(
        width: width != null ? 200 : 130,
        height: 60,
        child: Image.asset(
          "${appIcons.appLoader}",
          fit: BoxFit.cover,
        )),
  );
}
