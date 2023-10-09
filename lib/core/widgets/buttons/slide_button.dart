import 'package:flutter/material.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../../config/app_config.dart';

class WedgeSlideButton extends StatefulWidget {
  final PageController pageController;
  final int pageIndex;
  final String labelFirst;
  final String labelSecond;
  final double? textSize;
  final double? horizontalPadding;
  final double? verticalPadding;

  const WedgeSlideButton({
    Key? key,
    required this.pageController,
    required this.pageIndex,
    required this.labelFirst,
    required this.labelSecond,
    this.horizontalPadding,
    this.verticalPadding,
    this.textSize,
  }) : super(key: key);

  @override
  State<WedgeSlideButton> createState() => _WedgeSlideButtonState();
}

class _WedgeSlideButtonState extends State<WedgeSlideButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
          color: appThemeColors!.primary,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: appThemeColors!.primary!)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.pageController.animateToPage(0,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: widget.verticalPadding ?? 7,
                  horizontal: widget.horizontalPadding ?? 10),
              decoration: BoxDecoration(
                color: widget.pageIndex != 0
                    ? Colors.white
                    : appThemeColors!.primary,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(2)),
              ),
              child: Text(
                widget.labelFirst,
                textAlign: TextAlign.center,
                style: widget.pageIndex != 0
                    ? SubtitleHelper.h11
                    : TitleHelper.h12.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              widget.pageController.animateToPage(1,
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 500));
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: widget.verticalPadding ?? 7,
                  horizontal: widget.horizontalPadding ?? 10),
              decoration: BoxDecoration(
                color: widget.pageIndex != 1
                    ? Colors.white
                    : appThemeColors!.primary,
                borderRadius:
                    const BorderRadius.horizontal(right: Radius.circular(2)),
              ),
              child: Text(
                widget.labelSecond,
                textAlign: TextAlign.center,
                style: widget.pageIndex != 1
                    ? SubtitleHelper.h11
                    : TitleHelper.h11.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
