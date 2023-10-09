import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path/path.dart' as filepath;
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/data_models/theme_model.dart';

import '../../../../../core/common/functions/common_functions.dart';

class CreditCardWidget extends StatelessWidget {
  String? image;
  String? bankName;
  String? date;
  String? accountNumber;
  Function()? onTap;
  final backgroundColor;
  final country;
  final int index;
  final amount;
  final dynamic aggregatorData;
  final bool isYodlee;
  final bool isManual;
  final String? source;

  //manual
  CreditCardWidget(
      {super.key,
      required this.backgroundColor,
      this.amount,
      required this.index,
      this.accountNumber,
      required this.isYodlee,
      this.country,
      this.aggregatorData,
      this.bankName,
      this.source,
      this.isManual = true,
      this.date,
      this.onTap,
      this.image});

  @override
  Widget build(BuildContext context) {
    final List<String> rightValue = amount.split(" ");

    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 22,
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 15,
                  color: Colors.black12,
                ),
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: List.generate(backgroundColor.length,
                      (index) => HexColor(backgroundColor[index]))),
              borderRadius: BorderRadius.circular(kborderRadius)),
          height: 200,
          width: 300,
          child: Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(kborderRadius),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              image != null
                                  ? _getExtension("$image") ==
                                          ".SVG".toLowerCase()
                                      ? SvgPicture.network(
                                          "$image",
                                          width: 100,
                                          height: 40,
                                          alignment: Alignment.centerLeft,
                                          placeholderBuilder: (e) {
                                            return Text(bankName ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize:
                                                        appThemeHeadlineSizes!
                                                            .h9,
                                                    fontFamily:
                                                        appThemeSubtitleFont,
                                                    fontWeight:
                                                        appThemeHeadlineIsBold
                                                            ? FontWeight.w600
                                                            : null));
                                          },
                                        )
                                      : Container(
                                          width: 100,
                                          height: 40,
                                          alignment: Alignment.topLeft,
                                          child: Image.network(
                                            "$image",
                                            fit: BoxFit.contain,
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Text("${bankName ?? ""} ",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize:
                                                          appThemeHeadlineSizes!
                                                              .h9,
                                                      fontFamily:
                                                          appThemeHeadlineFont,
                                                      fontWeight:
                                                          appThemeHeadlineIsBold
                                                              ? FontWeight.w600
                                                              : null));
                                            },
                                          ),
                                        )
                                  : Text("${bankName ?? ""} ",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: appThemeHeadlineSizes!.h9,
                                          fontFamily: appThemeHeadlineFont,
                                          fontWeight: appThemeHeadlineIsBold
                                              ? FontWeight.w600
                                              : null)),
                              isManual
                                  ? connectionStatus()
                                  : (aggregatorData == null
                                      ? const SizedBox.shrink()
                                      : isAggregatorExpired(
                                              data: aggregatorData)
                                          ? connectionStatus(
                                              isDisconnected: true)
                                          : connectionStatus(
                                              isConnected: true)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: ShadowText(
                                  "${rightValue[0]} ${numberFormat.format(num.parse(rightValue[1]))}",
                                  style: TextStyle(
                                      fontSize: appThemeHeadlineSizes!.h8,
                                      fontFamily: appThemeHeadlineFont,
                                      color: appThemeColors!.primary,
                                      fontWeight: appThemeHeadlineIsBold
                                          ? FontWeight.w600
                                          : null))),
                          const SizedBox(height: 22),
                          Align(
                              alignment: Alignment.topLeft,
                              child: Text("$accountNumber",
                                  style: TextStyle(
                                    fontSize: appThemeHeadlineSizes!.h10,
                                    fontFamily: appThemeSubtitleFont,
                                  ))),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text("$country",
                                      style: TextStyle(
                                        fontSize: appThemeHeadlineSizes!.h11,
                                        fontFamily: appThemeSubtitleFont,
                                      ))),
                              date!.isEmpty
                                  ? Container()
                                  : Text(
                                      "As of ${dateFormatter.format(DateTime.parse(date!))}",
                                      style: TextStyle(
                                        fontSize: appThemeHeadlineSizes!.h11,
                                        fontFamily: appThemeSubtitleFont,
                                      )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(bottom: -110.0, left: -80.0, child: circle()),
                  Positioned(top: -180.0, right: -80.0, child: circle())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //connection Status Widget
  Widget connectionStatus(
      {bool isDisconnected = false, bool isConnected = false}) {
    Color widgetColor = isDisconnected
        ? Colors.red
        : isConnected
            ? Colors.green
            : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white38, borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Visibility(
            visible: isDisconnected,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image.asset(
                "assets/icons/warning.png",
                height: 14,
                color: Colors.red,
              ),
            ),
          ),
          Text(
              isDisconnected
                  ? "Disconnected"
                  : isConnected
                      ? "Linked"
                      : "Manual",
              style: TitleHelper.h12.copyWith(color: widgetColor)),
        ],
      ),
    );
  }

  String _getExtension(url) {
    try {
      final extension = filepath.extension(url);
      return extension;
    } on Exception catch (e) {
      return "";
    }
    // '.dart'
  }

  Widget circle() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
          color: Colors.black12.withOpacity(0.03),
          borderRadius: BorderRadius.circular(120.0)),
    );
  }
}

class ShadowText extends StatelessWidget {
  const ShadowText(this.data, {super.key, required this.style});

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            top: 2.0,
            bottom: 2.0,
            child: Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.3)),
            ),
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: Text(data, style: style),
          ),
        ],
      ),
    );
  }
}
