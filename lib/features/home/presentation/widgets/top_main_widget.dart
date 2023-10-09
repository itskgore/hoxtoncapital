import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:jiffy/jiffy.dart';
import 'package:wedge/core/config/app_config.dart';
import 'package:wedge/core/contants/string_contants.dart';
import 'package:wedge/core/contants/theme_contants.dart';
import 'package:wedge/core/entities/dashboard_entity.dart';
import 'package:wedge/core/utils/half_circle_painter.dart';

import 'networth_chart_widget.dart';

class TopMainBar extends StatelessWidget {
  DashboardDataEntity dashboardDataEntity;
  Function onComplete;

  TopMainBar(
      {Key? key, required this.dashboardDataEntity, required this.onComplete})
      : super(key: key);

  num calculateNetWorthForThisMonth() {
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month, 0);
    List<PerformacesData> currentMonthLastDay = [];
    List<PerformacesData> previousMonthLastDay = [];
    // getting current month last date inserted value
    dashboardDataEntity.data.performaces.forEach((element) {
      DateTime ww =
          DateTime.fromMillisecondsSinceEpoch(element.date * 1000).toUtc();
      if (ww.year == now.year && ww.month == now.month) {
        if (ww.day <= now.day) {
          currentMonthLastDay
              .add(PerformacesData(date: ww, networth: element.networth));
        }
      }
    });
    // getting last month last date inserted value
    for (var element in dashboardDataEntity.data.performaces) {
      DateTime ww =
          DateTime.fromMillisecondsSinceEpoch(element.date * 1000).toUtc();
      // print("Date: ${ww}");
      if (ww.year == lastDayOfMonth.year && ww.month == lastDayOfMonth.month) {
        if (ww.day <= lastDayOfMonth.day) {
          previousMonthLastDay
              .add(PerformacesData(date: ww, networth: element.networth));
        }
      }
    }

    currentMonthLastDay.sort((a, b) => a.date.compareTo(b.date));
    previousMonthLastDay.sort((a, b) => a.date.compareTo(b.date));
    num currentMonthLastDayNetWorth = currentMonthLastDay.isEmpty
        ? 0
        : currentMonthLastDay[currentMonthLastDay.length - 1].networth;
    num previousMonthLastDayNetWorth = previousMonthLastDay.isEmpty
        ? 0
        : previousMonthLastDay[previousMonthLastDay.length - 1].networth;
    var totalValue = currentMonthLastDayNetWorth - previousMonthLastDayNetWorth;
    return totalValue;
  }

  AppLocalizations? translate;

  @override
  Widget build(BuildContext context) {
    translate = translateStrings(context);
    return ClipPath(
      clipper: HalfCirclePainter(),
      child: Container(
        height: 460,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: appThemeColors!.gradient!),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Text(
                  "${dashboardDataEntity.data.baseCurrency} ${numberFormat.format(dashboardDataEntity.data.currentNetWorth)}",
                  style: TitleHelper.h4.copyWith(
                    color: kfontColorLight,
                    // fontSize: kfontexLarge,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${translateStrings(context)!.netWorth} ",
                      style: SubtitleHelper.h12.copyWith(
                          color: appThemeColors!.textLight,
                          fontWeight: FontWeight.w400),
                    ),
                    Container(
                        height: 17,
                        width: 17,
                        margin: const EdgeInsets.only(right: 5),
                        decoration: BoxDecoration(
                            color: calculateNetWorthForThisMonth().isNegative
                                ? Colors.red
                                : kgreen,
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                            child: Icon(
                          calculateNetWorthForThisMonth().isNegative
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          size: 10,
                          color: Colors.white,
                        ))),
                    Text(
                      "${dashboardDataEntity.data.baseCurrency} ${numberFormat.format(calculateNetWorthForThisMonth())}",
                      style: SubtitleHelper.h12.copyWith(
                          color: appThemeColors!.textLight,
                          fontWeight: FontWeight.w400),
                      maxLines: 1,
                    ),
                    Text(
                      " ${translate!.thisMonth}",
                      style: SubtitleHelper.h12.copyWith(
                          color: appThemeColors!.textLight,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${translate!.lastUpadted} ${Jiffy.parse(dashboardDataEntity.data.asAt).fromNow()}",
                  style: const TextStyle(
                      color: kfontColorLight,
                      fontStyle: FontStyle.italic,
                      fontSize: kfontSmall,
                      fontWeight: FontWeight.w200),
                ),
                Stack(
                  children: [
                    Opacity(
                        opacity: 1,
                        child: NetworthChart(
                            dashboardDataEntity: dashboardDataEntity)),
                  ],
                )
              ],
            ),
            // Container(),
            // Container()
          ],
        ),
      ),
    );
  }
}

class PerformacesData {
  DateTime date;
  num networth;

  PerformacesData({
    required this.date,
    required this.networth,
  });
}
