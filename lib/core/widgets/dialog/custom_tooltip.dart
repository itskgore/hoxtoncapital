import 'package:flutter/material.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

import '../../config/app_config.dart';
import '../../contants/theme_contants.dart';

class CustomToolTip extends StatelessWidget {
  String? message;
  Offset? targetCenter;
  Widget child;
  bool showToolTop;
  Color? backGroundColor;
  TooltipDirection tooltipDirection;
  Widget? icon;

  CustomToolTip({
    super.key,
    this.message,
    this.showToolTop = false,
    this.targetCenter,
    required this.child,
    this.tooltipDirection = TooltipDirection.up,
    this.backGroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color toolTopColor = const Color.fromRGBO(233, 161, 98, 1);
    return SimpleTooltip(
        tooltipDirection: tooltipDirection,
        show: showToolTop,
        backgroundColor: backGroundColor ?? toolTopColor,
        arrowLength: 5,
        maxWidth: size.width * .5,
        arrowTipDistance: 0,
        borderWidth: 0,
        borderRadius: 6,
        customShadows: [],
        ballonPadding: EdgeInsets.zero,
        targetCenter: targetCenter,
        arrowBaseWidth: 12,
        content: Material(
          color: backGroundColor ?? toolTopColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon ??
                  const Padding(
                    padding: EdgeInsets.only(left: 3, right: 6, top: 2),
                    child: Icon(Icons.info_outline, size: 18),
                  ),
              Expanded(
                child: Text("$message",
                    overflow: TextOverflow.visible,
                    style: SubtitleHelper.h11
                        .copyWith(color: appThemeColors!.primary)),
              ),
            ],
          ),
        ),
        child: child);
  }
}
