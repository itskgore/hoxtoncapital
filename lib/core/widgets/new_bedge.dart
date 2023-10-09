import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../contants/theme_contants.dart';

class NewBadge extends StatelessWidget {
  const NewBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Colors.white70,
        child: Text(
          "New",
          style: TitleHelper.h12.copyWith(color: appThemeColors!.primary),
        ),
      ),
    );
  }
}
