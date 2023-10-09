import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../../../../core/config/app_config.dart';

class widgetShareButton extends StatefulWidget {
  Function()? onPressed;
  IconData? icon;
  String? label;
  Color? iconColor;

  widgetShareButton(
      {Key? key, this.icon, this.label, this.onPressed, this.iconColor})
      : super(key: key);

  @override
  State<widgetShareButton> createState() => _widgetShareButtonState();
}

class _widgetShareButtonState extends State<widgetShareButton> {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: .8),
        ),
        onPressed: widget.onPressed,
        icon: FaIcon(
          widget.icon,
          size: 20,
          color: widget.iconColor,
        ),
        label: Text(
          "${widget.label}",
          style: SubtitleHelper.h12.copyWith(
              color: appThemeColors!.loginColorTheme!.textTitleColor,
              fontWeight: FontWeight.w600),
        ));
  }
}
