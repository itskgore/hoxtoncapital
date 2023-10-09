import 'package:flutter/material.dart';
import 'package:wedge/core/utils/wedge_func_methods.dart';

import '../contants/theme_contants.dart';

Widget popUpItem(
  String title, {
  Color color = Colors.black,
  String? subtitle,
  Color? highlightColor,
  bool highlight = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: highlight
                ? Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 9,
                        width: 9,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: highlightColor ?? const Color(0xffEA943E),
                        ),
                      ),
                    ],
                  )
                : null,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.left,
                  style: SubtitleHelper.h10.copyWith(
                    fontWeight: highlight ? FontWeight.w500 : null,
                    color: color,
                    decoration: highlight ? TextDecoration.underline : null,
                  ),
                ),
                subtitle == null || subtitle.isEmpty
                    ? const SizedBox()
                    : SizedBox(
                        width: size.width * .49,
                        child: Text(
                          subtitle ?? '',
                          softWrap: true,
                          textAlign: TextAlign.left,
                          style: SubtitleHelper.h12,
                          // TextStyle(color: appThemeColors!.textDark).copyWith(color: color),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
