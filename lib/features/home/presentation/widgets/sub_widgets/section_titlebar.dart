import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';

class SectionTitleBarHome extends StatelessWidget {
  final String title;
  Function? onTap;

  SectionTitleBarHome({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    var translate = translateStrings(context);
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TitleHelper.h10,
          ),
          onTap != null
              ? GestureDetector(
                  onTap: () {
                    onTap!();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: appThemeColors!.buttonLight!,
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Center(
                            child: Text(
                          translate!.view,
                          style: SubtitleHelper.h12
                              .copyWith(color: appThemeColors!.disableText),
                        )),
                      )),
                )
              : Container(),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
    ]);
  }
}
