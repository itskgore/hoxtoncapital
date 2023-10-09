import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../../contants/theme_contants.dart';

class DashboardValueCard extends StatelessWidget {
  final String mainValue;
  final String mainTitle;
  final String rightvalue;
  final String rightTitle;
  final String leftValue;
  final String leftTitle;
  final bool isFromHome;
  final void Function()? onRightTitleClicked;
  final void Function()? onLeftTitleClicked;

  const DashboardValueCard(
      {required this.mainValue,
      required this.mainTitle,
      required this.leftValue,
      required this.leftTitle,
      required this.rightTitle,
      required this.rightvalue,
      this.isFromHome = false,
      this.onRightTitleClicked,
      this.onLeftTitleClicked});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              // border: Border.all(width: 1, color: Colors.grey.shade300),
              color: appThemeColors!.primary,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: isFromHome
                        ? const EdgeInsets.only(top: 20, bottom: 10)
                        : const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Text(
                          mainValue,
                          style: TextStyle(
                            fontSize: kfontLarge,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: appThemeHeadlineFont,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          mainTitle,
                          style: TextStyle(
                              fontSize: 12,
                              fontFamily: appThemeHeadlineFont,
                              fontWeight: FontWeight.w400,
                              color: kgreyFont),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                height: 2,
                color: Colors.black12,
                width: MediaQuery.of(context).size.width,
              ),
              IntrinsicHeight(
                //for vetical divider
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: isFromHome
                            ? const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 12)
                            : const EdgeInsets.all(12.0),
                        child: Center(
                          child: TextButton(
                            onPressed: onLeftTitleClicked,
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  leftValue,
                                  style: TextStyle(
                                      fontSize: isFromHome ? 14 : kfontLarge,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontFamily: appThemeHeadlineFont,
                                      decoration: isFromHome
                                          ? TextDecoration.underline
                                          : null),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  leftTitle,
                                  style: TextStyle(
                                    fontSize: isFromHome ? 16 : 12,
                                    fontWeight: FontWeight.w400,
                                    color: kgreyFont,
                                    fontFamily: appThemeHeadlineFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalDivider(
                      width: 3.0,
                      thickness: 0.5,
                      color: Colors.black38,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                alignment: Alignment.centerLeft),
                            onPressed: onRightTitleClicked,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rightvalue,
                                  style: TextStyle(
                                      fontSize: isFromHome ? 14 : kfontLarge,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontFamily: appThemeHeadlineFont,
                                      decoration: isFromHome
                                          ? TextDecoration.underline
                                          : null),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  rightTitle,
                                  style: TextStyle(
                                      fontSize: isFromHome ? 16 : 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: appThemeHeadlineFont,
                                      color: kgreyFont),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
            top: 30,
            left: -90,
            child: IgnorePointer(ignoring: true, child: _circle())),
        Positioned(top: -250, right: -150, child: _circle())
      ],
    );
  }

  Widget _circle() {
    return Container(
      height: 300,
      width: 300,
      decoration: BoxDecoration(
          color: Colors.white10.withOpacity(0.05),
          borderRadius: BorderRadius.circular(150.0)),
    );
  }
}
