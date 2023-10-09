import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';

void showSnackBar(
    {required BuildContext context,
    required String title,
    Duration? duration}) {
  final snackBar = SnackBar(
    backgroundColor: Colors.black,
    duration: duration ?? const Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    behavior: SnackBarBehavior.floating,
    content: Text(
      title,
      style: SubtitleHelper.h10
          .copyWith(color: Colors.white, fontWeight: FontWeight.normal),
    ),
  );
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
