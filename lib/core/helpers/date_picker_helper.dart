import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../contants/theme_contants.dart';

class DatePickerHelper {
  static Future<DateTime?> showDatePickerData({
    required BuildContext context,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 100, DateTime.now().month),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: lighten(appThemeColors!.primary!, .2),
              onPrimary: appThemeColors!.textLight!,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    return picked;
  }
}
