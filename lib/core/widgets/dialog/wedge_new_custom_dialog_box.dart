import 'package:flutter/material.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/theme_contants.dart';

import '../buttons/app_button.dart';

class NewCustomDialogBox extends StatelessWidget {
  final String title;
  final String description;
  final TextStyle? descriptionStyle;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final String? bannerDescription;
  final bool isSuccess;
  final bool isTitleIconVisible;
  final bool showWarningIcon;
  final bool showReconnectIcon;
  final bool showBanner;
  final Widget? content;
  final Function? onPressedPrimary;
  final Function? onPressedSecondary;
  final Color? primaryButtonColor;

  NewCustomDialogBox({
    required this.title,
    required this.description,
    this.descriptionStyle,
    this.isTitleIconVisible = true,
    this.isSuccess = true,
    this.showBanner = false,
    this.bannerDescription,
    this.showWarningIcon = false,
    this.content,
    this.onPressedPrimary,
    this.onPressedSecondary,
    this.secondaryButtonText,
    this.primaryButtonText,
    this.showReconnectIcon = false,
    this.primaryButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 17),
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              blurRadius: 10,
              spreadRadius: 2,
              color: Colors.black38,
              offset: Offset(1, 1))
        ],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showBanner
              ? Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        title,
                        style: TitleHelper.h8.copyWith(color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.green.shade50),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              "assets/icons/success_check_circle.png",
                              width: 60,
                              height: 60,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                "$bannerDescription",
                                style: SubtitleHelper.h10
                                    .copyWith(color: Colors.teal.shade700),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(
                      decoration: showReconnectIcon
                          ? BoxDecoration(
                              color: const Color(0xffEA943E).withOpacity(.1),
                              borderRadius: BorderRadius.circular(50))
                          : null,
                      padding: const EdgeInsets.all(10),
                      child: Visibility(
                        visible: isTitleIconVisible,
                        child: Image.asset(
                          showWarningIcon
                              ? "assets/icons/warning_icon.png"
                              : showReconnectIcon
                                  ? 'assets/icons/reconnect_icon.png'
                                  : "assets/images/success_tick.png",
                          width: showReconnectIcon ? 35 : 60,
                          height: showReconnectIcon ? 35 : 60,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      title,
                      style: TitleHelper.h9
                          .copyWith(color: appThemeColors!.textDark),
                    ),
                  ],
                ),
          const SizedBox(height: 8.0),
          Visibility(
            visible: description != '',
            child: Text(
              description,
              textAlign: showBanner ? TextAlign.start : TextAlign.center,
              style: descriptionStyle ??
                  SubtitleHelper.h11.copyWith(color: Colors.black),
            ),
          ),
          Visibility(
              visible: content != null,
              child: Column(
                children: [
                  const SizedBox(height: 15.0),
                  content ?? const SizedBox.shrink()
                ],
              )),
          const SizedBox(height: 24.0),
          Row(
            children: <Widget>[
              Visibility(
                  visible: onPressedSecondary != null,
                  child: Expanded(
                    child: AppButton(
                      onTap: () {
                        onPressedSecondary!();
                      },
                      borderRadius: 5,
                      verticalPadding: 10,
                      label: "$secondaryButtonText",
                      color: Colors.white,
                      style: TitleHelper.h11
                          .copyWith(color: appThemeColors!.primary),
                      border: Border.all(color: appThemeColors!.primary!),
                    ),
                  )),
              Visibility(
                visible: onPressedSecondary != null && onPressedPrimary != null,
                child: const SizedBox(
                  width: 20,
                ),
              ),
              Visibility(
                visible: onPressedPrimary != null,
                child: Expanded(
                  child: AppButton(
                    color: primaryButtonColor,
                    onTap: () {
                      onPressedPrimary!();
                    },
                    borderRadius: 5,
                    verticalPadding: 10,
                    label: primaryButtonText ?? "OK",
                    style: TitleHelper.h11
                        .copyWith(color: appThemeColors!.textLight),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
