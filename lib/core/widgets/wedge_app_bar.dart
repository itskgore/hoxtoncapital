import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import '../utils/wedge_colors.dart';

class WedgeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WedgeAppBar({required this.heading, this.actions, Key? key})
      : super(key: key);
  final String heading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: appThemeColors!.bg,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: appThemeColors!.primary,
          ),
        ),
        actions: actions,
        title: Text(
          heading,
          style: TitleHelper.h8.copyWith(color: appThemeColors!.primary),
        ),
      );

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
