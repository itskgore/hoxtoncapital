import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../contants/theme_contants.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key,
      required this.onTap,
      this.label,
      this.isDisable = false,
      this.verticalPadding,
      this.style,
      this.color,
      this.textColor,
      this.border,
      this.horizontalPadding,
      this.borderRadius})
      : super(key: key);

  final Function onTap;
  final String? label;
  final bool isDisable;
  final Color? color;
  final Color? textColor;
  final double? verticalPadding;
  final double? horizontalPadding;
  final TextStyle? style;
  final double? borderRadius;
  final BoxBorder? border;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable
          ? null
          : () {
              onTap();
            },
      child: Container(
          decoration: BoxDecoration(
              color: isDisable
                  ? (color ?? appThemeColors!.primary!).withOpacity(.4)
                  : (color ?? appThemeColors!.primary!),
              border: border,
              borderRadius: BorderRadius.circular(borderRadius ?? 2.0)),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding ?? 20,
                vertical: verticalPadding ?? 5),
            child: Center(
                child: Text(
              label ?? "Add",
              style: style ??
                  SubtitleHelper.h12.copyWith(
                    color: isDisable
                        ? (textColor ?? Colors.white).withOpacity(.4)
                        : textColor ?? Colors.white,
                  ),
            )),
          )),
    );
  }
}
