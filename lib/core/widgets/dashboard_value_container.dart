// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../common/line_performance_graph/data/model/line_performance_model.dart';
import '../contants/string_contants.dart';

class DashboardValueContainer extends StatelessWidget {
  final String mainValue;
  final String mainTitle;
  final LastDayPerformance? summary;
  final String? rightvalue;
  final String? rightTitle;
  final String? leftValue;
  final String? leftTitle;
  final String? leftImage;
  final bool? isSingleTitle;
  final bool? showOnlyTop;

  const DashboardValueContainer({
    Key? key,
    required this.mainValue,
    required this.mainTitle,
    this.summary,
    this.rightvalue,
    this.rightTitle,
    this.leftValue,
    this.leftTitle,
    this.leftImage,
    this.isSingleTitle,
    this.showOnlyTop,
  }) : super(key: key);

  bool isPositive() {
    if (summary?.diff != null) {
      return summary!.diff! > 0;
    } else {
      return false;
    }
  }

  bool showSummary() {
    return (summary != null && summary?.diff != null && summary?.diff != 0);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> mainVal = mainValue.trimLeft().trimRight().split(" ");
    // log(summary?.diff.toString() ?? "null", name: "Diff");
    return Center(
      child: Container(
        // height: 155.0,
        margin: EdgeInsets.only(
          bottom: showOnlyTop ?? false ? 10 : 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${mainVal[0]} ${numberFormat.format(num.parse(mainVal[mainVal.length - 1]))}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: lighten(appThemeColors!.primary!, .0),
                  fontSize: mainValue.toString().length > 15
                      ? appTheme.fonts!.headline!.sizes!.h6
                      : appTheme.fonts!.headline!.sizes!.h5,
                  fontWeight: FontWeight.w600,
                  fontFamily: appThemeFonts!.headline!.font),
            ),
            const SizedBox(
              height: 5.0,
            ),
            if (showSummary()) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.flip(
                      flipY: !isPositive(),
                      child: SvgPicture.asset('assets/icons/arrow_up.svg')),
                  const SizedBox(width: 5),
                  Text(
                    "${isPositive() ? '+' : '-'}${mainVal[0]} ${numberFormat.format((summary?.diff ?? 0).abs())} (${isPositive() ? '+' : '-'}${numberFormat2.format((summary?.percentageGrowth ?? 0).abs())}%)",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: lighten(appThemeColors!.primary!, .0),
                        fontSize: mainValue.toString().length > 15
                            ? appTheme.fonts!.headline!.sizes!.h11
                            : appTheme.fonts!.headline!.sizes!.h12,
                        fontWeight: FontWeight.w600,
                        fontFamily: appThemeFonts!.headline!.font),
                  ),
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
            ],
            Text(
              mainTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: appThemeFonts!.subtitle!.sizes!.h10,
                  fontFamily: appThemeHeadlineFont,
                  color: appThemeColors!.disableText),
            ),
            showOnlyTop ?? false
                ? Container()
                : Column(
                    children: [
                      const SizedBox(
                        height: 25.0,
                      ),
                      (leftTitle != null || leftValue != null)
                          ? isSingleTitle != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      leftImage ??
                                          "${appIcons.assetsPaths!.secondaryIcon}",
                                      color: const Color(0xFF4F4F4F),
                                      width: 20,
                                    ),
                                    const SizedBox(
                                      width: 13,
                                    ),
                                    Text(
                                      "$leftValue $leftTitle",
                                      style: TextStyle(
                                          fontFamily: appThemeHeadlineFont,
                                          fontSize: appThemeFonts!
                                              .subtitle!.sizes!.h10,
                                          color: appThemeColors!.textDark),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          leftImage ??
                                              "${appIcons.assetsPaths!.secondaryIcon}",
                                          color: const Color(0xFF4F4F4F),
                                          width: 20,
                                        ),
                                        const SizedBox(
                                          width: 13,
                                        ),
                                        Text(
                                          "$leftValue $leftTitle",
                                          style: TextStyle(
                                              fontFamily: appThemeHeadlineFont,
                                              fontSize: appThemeFonts!
                                                  .subtitle!.sizes!.h10,
                                              color: appThemeColors!.textDark),
                                        )
                                      ],
                                    ),
                                    (rightvalue != null || rightTitle != null)
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                "${appIcons.countriesIcon}",
                                                width: 17,
                                              ),
                                              const SizedBox(
                                                width: 13,
                                              ),
                                              Text(
                                                "$rightvalue $rightTitle",
                                                style: TextStyle(
                                                    fontFamily:
                                                        appThemeHeadlineFont,
                                                    fontSize: appThemeFonts!
                                                        .subtitle!.sizes!.h10,
                                                    color: appThemeColors!
                                                        .textDark),
                                              )
                                            ],
                                          )
                                        : const SizedBox()
                                    // Container(
                                    //   height: 80.0,
                                    //   width: MediaQuery.of(context).size.width / 2.5,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(10.0),
                                    //       color: Color(0xfffEAEBE1)),
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         leftValue,
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.w600, fontSize: kfontLarge),
                                    //       ),
                                    //       Text(
                                    //         leftTitle,
                                    //         style: TextStyle(fontSize: kfontMedium),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 15.0,
                                    // ),
                                    // Container(
                                    //   height: 80.0,
                                    //   width: MediaQuery.of(context).size.width / 2.5,
                                    //   decoration: BoxDecoration(
                                    //       borderRadius: BorderRadius.circular(10.0),
                                    //       color: Color(0xfffEAEBE1)),
                                    //   child: Column(
                                    //     mainAxisAlignment: MainAxisAlignment.center,
                                    //     children: [
                                    //       Text(
                                    //         rightvalue,
                                    //         style: TextStyle(
                                    //             fontWeight: FontWeight.w600, fontSize: kfontLarge),
                                    //       ),
                                    //       Text(
                                    //         rightTitle,
                                    //         style: TextStyle(fontSize: kfontMedium),
                                    //       )
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                )
                          : const SizedBox(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
